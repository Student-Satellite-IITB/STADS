function q_bi = es_qdp(b_m, m_r, v_a)
% This function calculates quaternion using q-Davenport method
% input: (b_m,m_r,v_a)
%   where b_m((n,3) double matrix): [b1;b2;b3]
%   where m_r((n,3) double matrix): [r1;r2;r3]
%   where v_a((n,1) double vector): [a1;a2;a2]
%        where n: number of matched stars
% output: q((4,1) double vector):quaternion

%%Calculating required matrices

%size of input
%here v_p(1) represents the the number of matched stars
v_p = size(b_m);

%Calculating B matrix
m_B = zeros(3);

for i_rw = 1 : v_p(1)
    m_B = m_B + v_a(i_rw, 1) * (b_m(i_rw, :)') * m_r(i_rw, :);
end

%Calculating z vector
v_z = zeros(1, 3);

for i_rw = 1 : v_p(1)
    v_z = v_z + v_a(i_rw, 1) * cross(b_m(i_rw, :), m_r(i_rw, :));
end

v_z = v_z';


%Calculating K matrix
m_J = m_B + m_B' - trace(m_B) * eye(3);
m_K = [m_J(1, :) v_z(1) ; m_J(2, :) v_z(2) ; m_J(3, :) v_z(3) ; v_z' trace(m_B)];

%%Finding Eigenvalue
%Using 'eig' function to calculate maximum eigenvalue.
eign = eig(m_K);
m = max(eign);

%%Finding the final quaternion
o = m + trace(m_B);
m_S = m_B + m_B';
q_bi = [(adjoint(o * eye(3) - m_S)*v_z) ; det(o * eye(3) - m_S)];

%normalizing the quaternion
w = norm(q_bi,2);

if w~=0
    q_bi = q_bi / w;
    
end

%making the scaler component of the quaternion non-negative
if q_bi(4)<0
    q_bi = -q_bi;
end

    


end

