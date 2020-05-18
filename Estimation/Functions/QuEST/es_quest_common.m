function [m_B, v_z, lamnot] = es_quest_common(b_m, m_r, v_a)
%	This function calculates K , B and z vector
%   input type: (b,r,a)
%   where b: [b1;b2;b3]
%   where r: [r1;r2;r3]
%   where a: [a1;a2;a2]
%   output: [B, z, lamnot]

%%Calculating the required matrices
%Size of input
v_p = size(b_m);

%Calculating B matrix
m_B = zeros(v_p(2));

for i_rw = 1 : v_p(1)
    m_B = m_B + v_a(i_rw, 1) * b_m(i_rw, :)' * m_r(i_rw, :); 
end

%Calculating z matrix
v_z = zeros(1, v_p(2)) ;

for i_rw = 1 : v_p(1)
    v_z = v_z + v_a(i_rw, 1) * cross(b_m(i_rw, :), m_r(i_rw, :));
end

v_z = v_z' ;

%Calculating value of lambda-not
lamnot = 0;
for i_rw = 1 : v_p(1)
    lamnot = lamnot + v_a(i_rw);
end

end

