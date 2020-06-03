function q_bi = es_qdp(b_m, m_r, v_a)
% This function calculates quaternion using q-Davenport method
% input: (b,r,a)
%   where b: [b1;b2;b3]
%   where r: [r1;r2;r3]
%   where a: [a1;a2;a2]
% output: q(quaternion)

%%Calculating required matrices
%size of input
v_p = size(b_m);

%Calculating B matrix
m_B = zeros(v_p(2));

for i_rw = 1 : v_p(1)
    m_B = m_B + v_a(i_rw, 1) * b_m(i_rw, :)' * m_r(i_rw, :);
end

%Calculating z vector
v_z = zeros(1, v_p(2));

for i_rw = 1 : v_p(1)
    v_z = v_z + v_a(i_rw, 1) * cross(b_m(i_rw, :), m_r(i_rw, :));
end

v_z = v_z';


%Calculating K matrix
m_J = m_B + m_B' - trace(m_B) * eye(v_p(2));
m_K = [m_J(1, :) v_z(1) ; m_J(2, :) v_z(2) ; m_J(3, :) v_z(3) ; v_z' trace(m_B)];

%%Finding Eigenvalue
%Using 'eig' function to calculate maximum eigenvalue.
eign = eig(m_K);
m = max(eign);

%%Finding the final quaternion
o = m + trace(m_B);
m_S = m_B + m_B';
v_q = [adjoint(o * eye(v_p(2)) - m_S) * v_z ; det(o * eye(v_p(2)) - m_S)];

%normalizing the quaternion
w = norm(v_q);

q_bi = v_q / w;

end

