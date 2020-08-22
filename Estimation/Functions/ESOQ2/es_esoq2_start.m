function [m_B, v_z, lam] = es_esoq2_start(b_m, m_r, v_a, epsilon)
%	This function calculates B Matrix, z vector and maximums eigenvalue
%	value, lam
%   input: (b_m,m_r,v_a)
%   where b_m((n,3) double matrix): [b1;b2;b3]
%   where m_r((n,3) double matrix): [r1;r2;r3]
%   where v_a((n,1) double vector): [a1;a2;a2]
%   where epsilon(Float): It is the error acceptable in the value of (in 
%                          mathematical terms the maximum accepted value of)
%                          characteristic equation.
%   output: [m_B, v_z, lamnot]
%   where m_B((3,3) double matrix)
%   where v_z((3,1) double vector)
%   where lamn(Float)

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

%%Defining the characteristic equation of K matrix and its derivative 
m_S = m_B + m_B';
k = trace(adjoint(m_S));

%Characteristic equation
func = [1 0 (k - 2*(trace(m_B)^2) - (norm(v_z,2)^2)) -((v_z')*m_S*v_z + det(m_S)) ((trace(m_B)^4) + ((norm(v_z,2)^2) - k)*(trace(m_B)^2) - k*(norm(v_z,2)^2) + trace(m_B)*((v_z')*m_S*v_z + det(m_S)) - (v_z')*(m_S^2)*v_z)];

%Derivative of characteristic equation
funcprm = [4 0 (2*(k - 2*(trace(m_B)^2) - (norm(v_z,2)^2))) -((v_z')*m_S*v_z + det(m_S))];

%%Iterating using Newton Raphson to find the value of x for which func is
%%closest to zero
x = lamnot;

%iteration
    while polyval(func,x) > epsilon
        x = x - polyval(func,x) / polyval(funcprm,x);
    end

%%Defining lambda
lam = x;


end

