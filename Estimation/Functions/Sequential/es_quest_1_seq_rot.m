function q_bi = es_quest_1_seq_rot(b_m, m_r, v_a)
% This function calculates quaternion using QUEST 1 after applying sequential rotation
% input: (b_m,m_r,v_a)
%   where b_m((n,3) double matrix): [b1;b2;b3]
%   where m_r((n,3) double matrix): [r1;r2;r3]
%   where v_a((n,1) double vector): [a1;a2;a2]
%        where n: number of matched stars
% output: q_bi((4,1) double vector):quaternion

%loading the previous quaternion value
q_bi_prev = readmatrix('.\Estimation\Input\es_q_bi.csv');

%input epsilon(measure accepted value of Lost function)
epsilon = readmatrix('.\Estimation\Input\es_epsilon');

%trying the first rotation frame, which is a frame obtained by rotating the
%inertial frame by 180 degrees along the axis corresponding to the maximum 
%absolute component in q_bi_prev(1:3,1)
%ind is the index of the maximum absolute component in q_bi_prev(1:3,1)
[mx,ind] = max(abs(q_bi_prev(1:3,1)));
m_rot = [-1 0 0;0 -1 0;0 0 -1];
m_rot(ind,ind) = 1;
%if ind is 1, then m_rot = [1 0 0;0 -1 0;0 0 -1]
%if ind is 2, then m_rot = [-1 0 0;0 1 0;0 0 -1] and so on.

%applying the rotation matrix
m_r = m_r*m_rot;

%%applying algorithm Quest1
%Common part for QuEST
[m_B, v_z, lamnot] = es_quest_common(b_m, m_r, v_a);

%finding largest eigenvalue
lam = es_quest_newton(m_B, v_z, lamnot, epsilon);

%finding the quaternion using the calculated eigenvalue
q_bi = es_quest_1_final(m_B, v_z, lam);

%if the value of the returned quaternion is [-1;-1;-1;-1] then QUEST-1 has 
%failed again and we must use new sequential rotation 
if q_bi == [-1;-1;-1;-1]
    
    %changing the m_r vector back to the actual inertial frame
    m_r = m_r*m_rot;
    
    %setting q_bi_prev(ind) as zero since the rotation doesn't work in the
    %corresponding frame 
    q_bi_prev(ind,1) = 0;
    %finding the second maximum value in q_bi_prev(1:3,1) and the changing
    %the frame accordingly
    [mx,ind] = max(abs(q_bi_prev(1:3,1)));
    m_rot = [-1 0 0;0 -1 0;0 0 -1];
    m_rot(ind,ind) = 1;
    
    %applying the second rotation matrix
    m_r = m_r*m_rot;

    %%applying algorithm Quest1 again
    %Common part for QuEST
    [m_B, v_z, lamnot] = es_quest_common(b_m, m_r, v_a);

    %finding largest eigenvalue
    lam = es_quest_newton(m_B, v_z, lamnot, epsilon);

    %finding the quaternion using the calculated eigenvalue
    q_bi = es_quest_1_final(m_B, v_z, lam);
    
    %if the value of the returned quaternion is [-1;-1;-1;-1] then QUEST-1 has 
    %failed again and we must use new sequential rotation 
    if q_bi == [-1;-1;-1;-1]
        %changing the m_r vector back to the actual inertial frame
        m_r = m_r*m_rot;
        
        %setting q_bi_prev(ind) as zero since the rotation doesn't work in the
        %corresponding frame 
        q_bi_prev(ind,1) = 0;
        %finding the second maximum value in q_bi_prev(1:3,1) and the changing
        %the frame accordingly
        [mx,ind] = max(abs(q_bi_prev(1:3,1)));
        m_rot = [-1 0 0;0 -1 0;0 0 -1];
        m_rot(ind,ind) = 1;
    
        %applying the second rotation matrix
        m_r = m_r*m_rot;

        %%algorithm Quest1
        %Common part for QuEST
        [m_B, v_z, lamnot] = es_quest_common(b_m, m_r, v_a);
        
        %finding largest eigenvalue
        lam = es_quest_newton(m_B, v_z, lamnot, epsilon);
        
        %finding the quaternion using the calculated eigenvalue
        q_bi = es_quest_1_final(m_B, v_z, lam);
        
        %since sequential rotation cannot fail in all three frames
        %we don't have to check the if q = [-1;-1;-1;-1] third time
        
        %%finding the actual quaternion
        
        %v_axis_rotation corresponds to the axis of rotation
        v_axis_rotation = [0 0 0];
        v_axis_rotation(1,ind) = 1;
        v_temp = q_bi(4).*v_axis_rotation + cross(v_axis_rotation,q_bi(1:3));
        q_bi = [v_temp(1) ; v_temp(2) ; v_temp(3) ; -v_axis_rotation*q_bi(1:3)];
        
        
    else
        %%finding the actual quaternion
        
        %v_axis_rotation corresponds to the axis of rotation
        v_axis_rotation = [0 0 0];
        v_axis_rotation(1,ind) = 1;
        v_temp = q_bi(4).*v_axis_rotation + cross(v_axis_rotation,q_bi(1:3));
        q_bi = [v_temp(1) ; v_temp(2) ; v_temp(3) ; -v_axis_rotation*q_bi(1:3)];
        
    end
else
    %%finding the actual quaternion
    
    %v_axis_rotation corresponds to the axis of rotation
    v_axis_rotation = [0 0 0];
    v_axis_rotation(1,ind) = 1;
    v_temp = q_bi(4).*v_axis_rotation + cross(v_axis_rotation,q_bi(1:3));
    q_bi = [v_temp(1) ; v_temp(2) ; v_temp(3) ; -v_axis_rotation*q_bi(1:3)];
   
end

%since sequential only returns a unit vector so we don't have to worry
%about normalizing it

%making the scaler component of the quaternion non-negative
if q_bi(4,1)<0
    q_bi = -q_bi;
end

end

