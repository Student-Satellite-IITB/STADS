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

