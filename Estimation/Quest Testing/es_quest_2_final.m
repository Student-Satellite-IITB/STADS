function q_bi = es_quest_2_final(lam, m_B, v_z)
%UNTITLED This function calculates the final quaternion using quest1
%   input: (lam, B,z)
%   ouput: q (the final quaternion)

%%

v_p = size(m_B);
m_S = m_B + m_B';
m_J = (lam + trace(m_B)) * eye(v_p(2)) - m_S;

%%

m_H = [m_J(1, :) - v_z(1) ; m_J(2, :) - v_z(2) ; m_J(3, :) -v_z(3) ; -v_z' lam - trace(m_B)];
m_H = adjoint(m_H);
q_bi = m_H(:, 4);

w = norm(q_bi);

q_bi = q_bi / w;

end

