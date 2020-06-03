% u=[0.272379472472602111022302462516           1.08301805439555555910790149937         -0.359366773005409555910790149937];
% v=[0.2898030626583580555111512312578          1.15229663744866689137553104956         -0.382354774507524222044604925031];CosTheta = max(min(dot(u,v)/(norm(u)*norm(v)),1),-1);
u = [1 2 3];
v = [4 5 6];

now1 = tic();
for i = 1:1000
    angle = rad2deg(atan2(norm(cross(u,v)), dot(u,v)));
end
Time_1 = toc(now1)

now2 = tic();
for i = 1:1000
    angle_2 = rad2deg(2 * atan(norm(u*norm(v) - norm(u)*v) / norm(u * norm(v) + norm(u) * v)));
end
Time_2 = toc(now2)