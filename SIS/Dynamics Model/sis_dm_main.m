function sis_input = sis_dm_main(sis_input)
% This function estimates the attitude at some future time from the
% attitude and angular velocity at t = 0;
% Input : sis_input : contains the intial angular velocity, attitude and
%                     the moment of inertial matrix

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

function Mat = crossProdMat(omega)
    % Utility function to find the cross-product matrix
    Mat = [0 -omega(3) omega(2) ; omega(3) 0 -omega(1) ; -omega(2) omega(1) 0 ];
end

