function q = final_quest1(lam, B,z)
%UNTITLED This function calculates the final quaternion using quest1
%   input: (lam, B)
%   ouput: q (the final quaternion)

o = lam + trace(B);
S = B + B';
p = size(B);

q = [adjoint(o*eye(p(2))-S)*z; det(o*eye(p(2))-S)];
w = norm(q);

q = q/w;

end

