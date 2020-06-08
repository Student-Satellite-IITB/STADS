function lam = es_quest_newton(m_B, v_z, lamnot, epsilon)
%UNTITLED2 This function calculates the maximum eignvalue of K matrix
%   intput: (B,z, lamnot, epsilon)
%   where lamnot = sum of ai's
%         epsilon: It is the error acceptable in the value of
%         characteristic equation.
%   output: lam(minimum eigenvalue) 

%%Defining the characteristic equation of K matrix and its derivative 
m_S = m_B + m_B';
k = trace(adjoint(m_S));

%Characteristic equation
func = @(x) (x ^ 2 - trace(m_B) ^ 2 + k) * (x ^ 2 - trace(m_B) ^ 2 - norm(v_z) ^ 2) - (x - trace(m_B)) * (v_z' * m_S * v_z + det(m_S)) - v_z' * m_S ^ 2 * v_z;

%Derivative of characteristic equation
funcprm = @(x) 2 * x * (2 * x ^ 2 - 2 * trace(m_B) ^ 2 + k - norm(v_z) ^ 2) - (v_z' * m_S * v_z + det(m_S));

%%Iterating using Newton Raphson to find the value of x for which func is
%%closest to zero

%Introducing small error to x to make it more robust(This is step is NOT mandatory)
x = lamnot + epsilon;

%iteration
    while func(x) > epsilon
        x = x - func(x) / funcprm(x);
    end

%%Defining lambda
lam = x;

end

