function q_bi = es_esoq2_final(m_B, v_z, lam)
%UNTITLED This function calculates the final quaternion using ESOQ2
%   input: (m_B,v_z,lam)
%   where m_B((3,3) double matrix)
%   where v_z((3,1) double vector)
%   where lam(Float): maximum eigenvalue
%   ouput: q_bi((4,1) double vector) :the final quaternion

%input the maximum value to allow sequential rotation
es_seq_error = readmatrix('.\Estimation\Input\es_seq_error');

%%Finding the K matrix
m_J = m_B + m_B' - trace(m_B) * eye(3);
m_K = [m_J(1, :) v_z(1) ; m_J(2, :) v_z(2) ; m_J(3, :) v_z(3) ; v_z' trace(m_B)];

%%Defining the Required quantites
o = lam + trace(m_B);
m_S = m_B + m_B';


%%if (lam - trace(m_B)) is close to zero, we have to use sequential matrix
check_value = (lam - trace(m_B));
if check_value < es_seq_error
    %assigning the quaternion a dummy value so as to command the main
    %script to do sequential rotation
    q_bi = [-1;-1;-1;-1];
else
    %%Defining the M matrix
    m_M = (lam - trace(m_B)) * (o * eye(3) - m_S) - v_z * v_z';
    
    %%Finding the maximum cross product between columns of m_m
    v_e = zeros(1,3);
    v_e(1,1) = norm(cross(m_M(:,2),m_M(:,3)),2);
    v_e(1,2) = norm(cross(m_M(:,3),m_M(:,1)),2);
    v_e(1,3) = norm(cross(m_M(:,1),m_M(:,2)),2);
    
    %storing the index of maximum cross product
    [mx, ind] = max(v_e);
    
    if ind == 1
        v_temp = (lam - trace(m_B)) * (cross(m_M(:,2),m_M(:,3)));
        q_bi = [v_temp(1); v_temp(2); v_temp(3); dot(v_z,(cross(m_M(:,2),m_M(:,3)))) ];
    elseif ind == 2
        v_temp = (lam - trace(m_B)) * (cross(m_M(:,3),m_M(:,1)));
        q_bi = [v_temp(1); v_temp(2); v_temp(3); dot(v_z,(cross(m_M(:,3),m_M(:,1))))];
    elseif ind == 3
        v_temp = (lam - trace(m_B)) * (cross(m_M(:,1),m_M(:,2)));
        q_bi = [v_temp(1); v_temp(2); v_temp(3); dot(v_z,(cross(m_M(:,1),m_M(:,2))))];
    end
    
    
    
    %normalizing the quaternion
    w = norm(q_bi,2);
    
    if w~=0
        q_bi = q_bi / w;
    
    end

    %making the scaler component of the quaternion non-negative
    if q_bi(4,1)<0
        q_bi = -q_bi;
    end
    
    
    
end


