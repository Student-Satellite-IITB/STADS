 function q_bi = es_esoq2_seq_rot(b_m, m_r, v_a, epsilon)
% This function calculates quaternion using ESOQ2 after applying sequential rotation
% input: (b_m,m_r,v_a)
%   where b_m((n,3) double matrix): [b1;b2;b3]
%   where m_r((n,3) double matrix): [r1;r2;r3]
%   where v_a((n,1) double vector): [a1;a2;a2]
%   where n: number of matched stars
%   where epsilon(Float): It is the error acceptable in the value of (in 
%                          mathematical terms the maximum accepted value of)
%                          characteristic equation.
% output: q_bi((4,1) double vector):quaternion

%%Calculating the required matrices

%Size of input
%here v_p(1) represents the number of matched stars
v_p = size(b_m);

%Calculating B matrix
m_B = zeros(3);

for i_rw = 1 : v_p(1)
    m_B = m_B + v_a(i_rw, 1) * (b_m(i_rw, :)') * m_r(i_rw, :); 
end


%storing the diagonal values of B matrix
v_diagonal = zeros(1,3);
v_diagonal(1,1) = m_B(1,1);
v_diagonal(1,2) = m_B(2,2);
v_diagonal(1,3) = m_B(3,3);


%trying the first rotation frame, which is a frame obtained by rotating the
%inertial frame by 180 degrees along the axis corresponding to the maximum 
%absolute component in q_bi_prev(1:3,1)
%ind is the index of the maximum absolute component in q_bi_prev(1:3,1)
[mx,ind] = max(abs(v_diagonal));
m_rot = [-1 0 0;0 -1 0;0 0 -1];
m_rot(ind,ind) = 1;
%if ind is 1, then m_rot = [1 0 0;0 -1 0;0 0 -1]
%if ind is 2, then m_rot = [-1 0 0;0 1 0;0 0 -1] and so on.

%applying the rotation matrix
m_r = m_r*m_rot;

%%usign the algorithm ESOQ2 again
%First part for ESOQ2, which also includes finding the maximumx eigenvalue
[m_B, v_z, lam] = es_esoq2_start(b_m, m_r, v_a, epsilon);

%finding the quaternion using the calculated eigenvalue
q_bi = es_esoq2_final(m_B, v_z, lam);

%if the value of the returned quaternion is [-1;-1;-1;-1] then ESOQ2 has 
%failed again and we must use new sequential rotation 
if q_bi == [-1;-1;-1;-1]
    
    %changing the m_r vector back to the actual inertial frame
    m_r = m_r*m_rot;
    
    %setting q_bi_prev(ind) as zero since the rotation doesn't work in the
    %corresponding frame 
    v_diagonal(1,ind) = 0;
    %finding the second maximum value in q_bi_prev(1:3,1) and the changing
    %the frame accordingly
    [mx,ind] = max(abs(v_diagonal));
    m_rot = [-1 0 0;0 -1 0;0 0 -1];
    m_rot(ind,ind) = 1;
    
    %applying the second rotation matrix
    m_r = m_r*m_rot;

    %%using algorithm ESOQ2 again
    %First part for ESOQ2, which also includes finding the maximumx eigenvalue
    [m_B, v_z, lam] = es_esoq2_start(b_m, m_r, v_a, epsilon);
    
    %finding the quaternion using the calculated eigenvalue
    q_bi = es_esoq2_final(m_B, v_z, lam);
    
    %if the value of the returned quaternion is [-1;-1;-1;-1] then ESOQ2 has 
    %failed again and we must use new sequential rotation 
    if q_bi == [-1;-1;-1;-1]
        %changing the m_r vector back to the actual inertial frame
        m_r = m_r*m_rot;
        
        %setting q_bi_prev(ind) as zero since the rotation doesn't work in the
        %corresponding frame 
        v_diagonal(1,ind) = 0;
        %finding the second maximum value in q_bi_prev(1:3,1) and the changing
        %the frame accordingly
        [mx,ind] = max(abs(q_bi_prev(1:3,1)));
        m_rot = [-1 0 0;0 -1 0;0 0 -1];
        m_rot(ind,ind) = 1;
    
        %applying the second rotation matrix
        m_r = m_r*m_rot;

        %%usign the algorithm ESOQ2 again
        %First part for ESOQ2, which also includes finding the maximumx eigenvalue
        [m_B, v_z, lam] = es_esoq2_start(b_m, m_r, v_a, epsilon);
        
        %finding the quaternion using the calculated eigenvalue
        q_bi = es_esoq2_final(m_B, v_z, lam);
        
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

