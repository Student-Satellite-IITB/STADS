function lam = es_quest_newton(m_B, v_z, lamnot, epsilon)
%UNTITLED2 This function calculates the maximum eignvalue of K matrix
%   intput: (B,z, lamnot, epsilon)
%   where lamnot = sum of ai's
%         epsilon: It is the error acceptable in the value of
%         characteristic equation.
%   output: lam(minimum eigenvalue) 

%%
m_S = m_B + m_B';
k = trace(adjoint(m_S));
func = @(x) (x ^ 2 - trace(m_B) ^ 2 + k) * (x ^ 2 - trace(m_B) ^ 2 - norm(v_z) ^ 2) - (x - trace(m_B)) * (v_z' * m_S * v_z + det(m_S)) - v_z' * m_S ^ 2 * v_z;
funcprm = @(x) 2 * x * (2 * x ^ 2 - 2 * trace(m_B) ^ 2 + k - norm(v_z) ^ 2) - (v_z' * m_S * v_z + det(m_S));
%f if the characteristic equation for the K matrix
%fp is the first derivative of f
%%

x = lamnot + epsilon;

    while func(x) > epsilon
        x = x - func(x) / funcprm(x);
    end

%% 

lam = x;

end

