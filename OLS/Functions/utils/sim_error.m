function final_error = sim_error(sis_input_attitude, es_output)
%SIM_ERROR Summary of this function goes here
%   Detailed explanation goes here


%q is matrix with each row corresponding to a reference quaternion
q = angle2quat(deg2rad(sis_input_attitude(1)), deg2rad(-sis_input_attitude(2)), deg2rad(-sis_input_attitude(3)), 'ZYX');


q_ref = [-q(2:4) q(1)];
q_ref = q_ref';


%estimated quaternion
q_esti = es_output.q_bi;

%disp(sis_input_attitude)
%disp(q_ref)
%disp(q_esti)



%calculating the 4,3 matrix used to calculate the error quaternion
some_matrix = [q_esti(4) -q_esti(3) q_esti(2); q_esti(3) q_esti(4) -q_esti(1); -q_esti(2) q_esti(1) q_esti(4); -q_esti(1) -q_esti(2) -q_esti(3)];


%error quaternion
error_quat = zeros(1,4);
error_quat(2:4) = ((1/(norm(q_esti)^2))*(some_matrix')*(q_ref))';
error_quat(1) = (1/(norm(q_esti)^2))*(q_esti')*(q_ref);    


%euler angles
eu = zeros(1,3);
[eu(1), eu(2), eu(3)] = quat2angle(error_quat);


final_error = [abs(rad2deg(eu(1))*3600) abs(rad2deg(eu(2))*3600) abs(rad2deg(eu(3))*3600) max([abs(rad2deg(eu(1))*3600) abs(rad2deg(eu(2))*3600) abs(rad2deg(eu(3))*3600)])];
end

