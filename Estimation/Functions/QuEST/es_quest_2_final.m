function q_bi = es_quest_2_final(lam, m_B, v_z)
%UNTITLED This function calculates the final quaternion using quest1
%   input: (lam, B,z)
%   ouput: q (the final quaternion)

%%Defining the Required quantites
v_p = size(m_B);
m_S = m_B + m_B';
m_J = (lam + trace(m_B)) * eye(v_p(2)) - m_S;

%%Defining the H matrix
m_H = [m_J(1, :) - v_z(1) ; m_J(2, :) - v_z(2) ; m_J(3, :) -v_z(3) ; -v_z' lam - trace(m_B)];

%Adjoint of H matrix
m_H = adjoint(m_H);

%fourth column of Adjoint of H matrix 
q_bi = m_H(:, 4);

%%normalizing the quaternion
w = norm(q_bi);

q_bi = q_bi / w;

end

