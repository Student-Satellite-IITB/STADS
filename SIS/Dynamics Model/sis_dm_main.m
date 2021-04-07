function sis_input = sis_dm_main(sis_input)
% Here angles in radians

%syms omega(t) [3 1]
%syms R(t) [3 3]
%
%ode1 = diff(R) == [0 -omega3 omega2 ; omega3 0 -omega1 ; -omega2 omega1 0 ]*R;
%%ode1 = diff(R) == -cross(omega,R);
%ode2 = diff(omega) == inv(sis_input.gen.J)*(-cross(-omega,(sis_input.gen.J*omega)));
%odes = [ode1 ode2];    
%
%cond1 = R(0) == eul2rotm([sis_input.bo.RA, -sis_input.bo.Dec, -sis_input.bo.Roll], 'ZYX');
%cond2 = omega(0) == [sis_input.bo.Ang_1 ; sis_input.bo.Ang_2 ; sis_input.bo.Ang_3];
%conds = [cond1 cond2];
%
%[RSol(t), omegaSol(t)] = dsolve(odes,conds);

%{
tRange = [0 sis_input.gen.N_bo/sis_input.lls.Capture_Rate];
Y0 = [reshape(eul2rotm([sis_input.bo.RA, -sis_input.bo.Dec, -sis_input.bo.Roll]*pi/180, 'ZYX'),[],1);[sis_input.bo.Ang_1 ; sis_input.bo.Ang_2 ; sis_input.bo.Ang_3]*pi/180];
sol = ode45(@(t,y) derivative(t,y,sis_input.gen.J), tRange, Y0);

%for i = 1:1000
%    R = deval(sol,i);
%    disp(norm(rotm2quat(reshape(R(1:9),3,[]))));
%end


attitude_arr = zeros(3,3+3,sis_input.gen.N_bo);

for i = 1:sis_input.gen.N_bo
    for j = 1:sis_input.gen.N_sub_im
        R = deval(sol,(j*sis_input.lls.Exposure_Time/sis_input.gen.N_sub_im + (i-1)/sis_input.lls.Capture_Rate));
        attitude_arr(j,1:3,i) = rotm2eul(reshape(R(1:9),3,[]))*[1,0,0 ; 0, -1, 0 ; 0, 0, -1]*180/pi;
    end
    attitude_arr(:,4:6,i) = [cosd(attitude_arr(:,2,i)) .* cosd(attitude_arr(:,1,i)), cosd(attitude_arr(:,2,i)) .* sind(attitude_arr(:,1,i)), sind(attitude_arr(:,2,i))];
end
%}

%rot = eul2rotm([sis_input.bo.RA, -sis_input.bo.Dec, -sis_input.bo.Roll], 'ZYX');
%
%arr = zeros(3,3+3,sis_input.gen.N_bo);
%
%for i = 1:sis_input.gen.N_bo
%    omega = [0 , -sis_input.bo.Ang_3(i), sis_input.bo.Ang_2(i) ; sis_input.bo.Ang_3(i) 0 -sis_input.bo.Ang_1(i) ; -sis_input.bo.Ang_2(i) sis_input.bo.Ang_1(i) 0];
%    for t = 1:sis_input.gen.N_sub_im
%        arr(t,1:3,i) = rotm2eul(rot(:,:,i) + (sis_input.lls.Exposure_Time/sis_input.gen.N_sub_im) * (omega*rot(:,:,i)));
%    end
%    
%    arr(:,4:6,i) = [cosd(arr(:,2,i)) .* cosd(arr(:,1,i)), cosd(arr(:,2,i)) .* sind(arr(:,1,i)), sind(arr(:,2,i))];
%    
%end
%{
tRange = [0 sis_input.gen.N_bo/sis_input.lls.Capture_Rate];
Y0 = [reshape(eul2rotm([sis_input.bo.RA, -sis_input.bo.Dec, -sis_input.bo.Roll]*pi/180, 'ZYX'),[],1);[sis_input.bo.Ang_1 ; sis_input.bo.Ang_2 ; sis_input.bo.Ang_3]*pi/180];
sol = ode45(@(t,y) derivative(t,y,sis_input.gen.J), tRange, Y0);
%}

R_t = eul2rotm([sis_input.bo.RA, -sis_input.bo.Dec, -sis_input.bo.Roll]*pi/180, 'ZYX');
o_t = [sis_input.bo.Ang_1 ; sis_input.bo.Ang_2 ; sis_input.bo.Ang_3]*pi/180;
J = sis_input.gen.J;
delta_t_1 = sis_input.lls.Exposure_Time/sis_input.gen.N_sub_im;
attitude_arr = zeros(3,3+3,sis_input.gen.N_bo);

for i = 1:sis_input.gen.N_bo
    for j = 1:sis_input.gen.N_sub_im
        R_t = R_t*expm(crossProdMat(o_t)*delta_t_1);
        o_t = o_t + (inv(J)*(-cross(-o_t,(J*o_t))))*delta_t_1;
        attitude_arr(j,1:3,i) = rotm2eul(R_t)*[1,0,0 ; 0, -1, 0 ; 0, 0, -1]*180/pi;
    end
    for j = 1:(1000/sis_input.lls.Capture_Rate - 1000*sis_input.lls.Exposure_Time)
        delta_t_2 = 0.001;
        R_t = R_t*expm(crossProdMat(o_t)*delta_t_2);
        o_t = o_t + (inv(J)*(-cross(-o_t,(J*o_t))))*delta_t_2;
    end
    attitude_arr(:,4:6,i) = [cosd(attitude_arr(:,2,i)) .* cosd(attitude_arr(:,1,i)), cosd(attitude_arr(:,2,i)) .* sind(attitude_arr(:,1,i)), sind(attitude_arr(:,2,i))];
end


sis_input.bo = attitude_arr;

end

%function omega_mat = skew(omega_vec)
%omega_mat=[0 -omega_vec3 omega_vec2 ; omega_vec3 0 -omega_vec1 ; -omega_vec2 omega_vec1 0 ];
%end

function Mat = crossProdMat(omega)
    Mat = [0 -omega(3) omega(2) ; omega(3) 0 -omega(1) ; -omega(2) omega(1) 0 ];
end
%{
function dYdt = derivative(t,Y,J)
    %disp(Y)
    R = reshape(Y(1:9),3,3);
    %disp(R * R')
    %disp(det(R))
    O = Y(10:12);
    %disp(O)
    dRdt = [0 -O(3) O(2) ; O(3) 0 -O(1) ; -O(2) O(1) 0 ]*R;
    dOdt = inv(J)*(-cross(-O,(J*O)));
    
    dYdt = [reshape(dRdt,[],1);dOdt];

end
%}
