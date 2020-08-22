function q_bi = es_quest_1_final(m_B, v_z, lam)
%UNTITLED This function calculates the final quaternion using quest1
%   input: (m_B,v_z,lam)
%   where m_B((3,3) double matrix)
%   where v_z((3,1) double vector)
%   where lam(Float): maximum eigenvalue
%   ouput: q((4,1) double vector) :the final quaternion

%input the maximum value to allow sequential rotation
es_seq_error = readmatrix('.\Estimation\Input\es_seq_error');

%%Defining the Required quantites
o = lam + trace(m_B);
m_S = m_B + m_B';

%%if (o * eye(3) - m_S) is singular we have to use sequential matrix
check_value = det(o * eye(3) - m_S);
if check_value < es_seq_error
    %assigning the quaternion a dummy value so as to command the main
    %script to do sequential rotation
    q_bi = [-1;-1;-1;-1];
else
    %%Defining the quaternion
    q_bi = [(adjoint(o * eye(3) - m_S)*v_z) ; det(o * eye(3) - m_S)];
    
    
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


    
end

