function [m_B, v_z, lamnot] = es_quest_common(b_m, m_r, v_a)
%	This function calculates B Matrix, z vector and lamnot value
%   input: (b_m,m_r,v_a)
%   where b_m((n,3) double matrix): [b1;b2;b3]
%   where m_r((n,3) double matrix): [r1;r2;r3]
%   where v_a((n,1) double vector): [a1;a2;a2]
%   output: [m_B, v_z, lamnot]
%   where m_B((3,3) double matrix)
%   where v_z((3,1) double vector)
%   where lamnot(Float)

%%Calculating the required matrices

%Size of input
%here v_p(1) represents the number of matched stars
v_p = size(b_m);

%Calculating B matrix
m_B = zeros(3);

for i_rw = 1 : v_p(1)
    m_B = m_B + v_a(i_rw, 1) * (b_m(i_rw, :)') * m_r(i_rw, :); 
end

%Calculating z matrix
v_z = zeros(1, 3) ;

for i_rw = 1 : v_p(1)
    v_z = v_z + v_a(i_rw, 1) * cross(b_m(i_rw, :), m_r(i_rw, :));
end

v_z = v_z' ;

%Calculating value of lambda-not
lamnot = 0;
for i_rw = 1 : v_p(1)
    lamnot = lamnot + v_a(i_rw, 1);
end

end

