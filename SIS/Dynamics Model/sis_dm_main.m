function sis_input = sis_dm_main(sis_input)
% Here angles in radians
rot = eul2rotm([sis_input.bo.RA, -sis_input.bo.Dec, -sis_input.bo.Roll], 'ZYX');

arr = zeros(3,3+1,sis_input.gen.N_bo);

for i = 1:sis_input.gen.N_bo
    omega = [0 , -sis_input.bo.Ang_3(i), sis_input.bo.Ang_2(i) ; sis_input.bo.Ang_3(i) 0 -sis_input.bo.Ang_1(i) ; -sis_input.bo.Ang_2(i) sis_input.bo.Ang_1(i) 0];
    for t = 1:sis_input.gen.N_sub_im
        arr(t,1:3,i) = rotm2eul(rot - (t/sis_input.gen.N_sub_im) * cross(omega,rot(:,:,i)));
    end
    
    arr(:,4,i) = [cosd(arr(:,2,i)) .* cosd(arr(:,1,i)), cosd(arr(:,2,i)) .* sind(arr(:,1,i)), sind(arr(:,2,i))];
    
end

sis_input.bo = arr;

end

