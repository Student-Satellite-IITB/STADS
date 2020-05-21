function lam = es_quest_newton(m_B, v_z, lamnot, epsilon)
%UNTITLED2 This function calculates the maximum eignvalue of K matrix
%   intput: (m_B,v_z, lamnot, epsilon)
%   where m_B((3,3) double matrix)
%   where v_z((3,1) double vector)
%   where lamnot(Float): It its the sum of all weights
%   where epsilon(Float): It is the error acceptable in the value of (in 
%                          mathematical terms the maximum accepted value of)
%                          characteristic equation.
%   output: lam(Float): maximum eigenvalue of K matrix 

%%Defining the characteristic equation of K matrix and its derivative 
m_S = m_B + m_B';
k = trace(adjoint(m_S));

%Characteristic equation
func = @(x) (x ^ 2 - trace(m_B) ^ 2 + k) * (x ^ 2 - trace(m_B) ^ 2 - norm(v_z) ^ 2) - (x - trace(m_B)) * (v_z' * m_S * v_z + det(m_S)) - v_z' * m_S ^ 2 * v_z;

%Derivative of characteristic equation
funcprm = @(x) 2 * x * (2 * x ^ 2 - 2 * trace(m_B) ^ 2 + k - norm(v_z) ^ 2) - (v_z' * m_S * v_z + det(m_S));

%%Iterating using Newton Raphson to find the value of x for which func is
%%closest to zero


%iteration
    while func(x) > epsilon
        x = x - func(x) / funcprm(x);
    end

%%Defining lambda
lam = x;

end

