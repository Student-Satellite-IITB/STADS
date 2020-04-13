function q = qdp(b,r,a)
% This function calculates quaternion using q-Davenport method
% input: (b,r,a)
%   where b: [b1;b2;b3]
%   where r: [r1;r2;r3]
%   where a: [a1;a2;a2]
% output: q(quaternion)
p = size(b);
B = zeros(p(2));

for i =1:p(1)
    B = B + a(i,1)*b(i,:)'*r(i,:);
end

z = zeros(1,p(2));

for i= 1:p(1)
    z = z + a(i,1)*cross(b(i,:),r(i,:));
end

z = z';

J = B + B' - trace(B)*eye(p(2));
K = [J(1,:) z(1);J(2,:) z(2);J(3,:) z(3);z' trace(B)];

e = eig(K); %This function calculates eignevalue for K matrix
m = max(e);


o = m + trace(B);
S = B + B';

q = [adjoint(o*eye(p(2))-S)*z; det(o*eye(p(2))-S)];
w = norm(q);

q = q/w;

end

