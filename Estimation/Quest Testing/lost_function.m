function [L] = lost_function(b,r,a,q)
%This function calculates the lost function for a given quaternion after
%converting it into the rotation matrix
%   input: (b,r,a,q)
%   output: L

A = [q(1)^2-q(2)^2-q(3)^2+q(4)^2 , 2*(q(1)*q(2)+q(3)*q(4)) , 2*(q(1)*q(3)-q(2)*q(4));
    2*(q(2)*q(1)-q(3)*q(4)) , -q(1)^2+q(2)^2-q(3)^2+q(4)^2 , 2*(q(2)*q(3)+q(1)*q(4)) ;
    2*(q(3)*q(1)+q(2)*q(4)) , 2*(q(3)*q(2)-q(1)*q(4)) , -q(1)^2-q(2)^2+q(3)^2+q(4)^2];
L = 0;
p = size(b);
for i=1:p(1)
    L = 0.5*a(i)*norm(b(i,:)' - A*r(i,:)')^2;
    
end
    
end

