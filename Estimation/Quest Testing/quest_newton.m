function lam = quest_newton(B,z, lamnot, epsilon)
%UNTITLED2 This function calculates the Maximum eignvalue of K matrix
%   intput: (B,z, lamnot, epsilon)
%       where lamnot = sum of ai's
%             epsilon: It is the error acceptable in the value of
%             characteristic equation.
%   output: lam(minimum eigenvalue) 

S = B + B';
k = trace(adjoint(S));
f = @(x) (x^2 - trace(B)^2 + k)*(x^2 - trace(B)^2 - norm(z)^2) -(x-trace(B))*(z'*S*z + det(S)) -z'*S^2*z;
fp = @(x) 2*x*(2*x^2 - 2*trace(B)^2 + k - norm(z)^2) - (z'*S*z + det(S));
%f if the characteristic equation for the K matrix
%fp is the first derivative of f

x = lamnot + epsilon;
    while f(x) > epsilon
        x = x - f(x)/fp(x);
    end

    
lam = x;

end

