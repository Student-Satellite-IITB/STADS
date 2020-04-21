function q = final_quest2(lam,B,z)
%UNTITLED This function calculates the final quaternion using quest1
%   input: (lam, B,z)
%   ouput: q (the final quaternion)
p = size(B);
S = B + B';
J = (lam+trace(B))*eye(p(2)) - S;

H = [J(1,:) -z(1) ; J(2,:) -z(2) ; J(3,:) -z(3) ; -z' lam-trace(B)];
H = adjoint(H);
q = H(:,4);

w = norm(q);

q = q/w;
end

