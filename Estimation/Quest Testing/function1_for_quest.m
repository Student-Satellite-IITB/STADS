function [K, B, z, lamnot] = function1_for_quest(b,r ,a)
%	This function calculates K , B and z vector
%   input type: (b,r,a)
%   where b: [b1;b2;b3]
%   where r: [r1;r2;r3]
%   where a: [a1;a2;a2]
%   output: [K, B, z, lamnot]
lamnot = 0;
p = size(b) ;
B = zeros(p(2)) ;
for i = 1 : p(1)
    B = B + a(i,1)*b(i, :)' * r(i, :); 
end

z = zeros(1, p(2)) ;

for i = 1 : p(1)
    z = z + a(i,1)*cross(b(i, :), r(i, :)) ;
end

z = z' ;

for i = 1 : p(1)
    lamnot = lamnot + a(i);
end

J = B + B' - trace(B) * eye(p(2)) ;
K = [J(1, :) z(1) ; J(2, :) z(2) ; J(3, :) z(3) ; z' trace(B)] ;

end

