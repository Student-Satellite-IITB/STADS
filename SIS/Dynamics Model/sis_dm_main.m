function sis_input = sis_dm_main(sis_input)
% Here angles in radians

%syms omega(t) R(t)

%ode1 = diff(R) == -skew([sis_input.bo.Ang_1 sis_input.bo.Ang_2 sis_input.bo.Ang_2]')*R;
%ode2 = diff(omega) == ;
%odes = [ode1; ode2];
%cond1 = u(0) == 0;
%cond2 = v(0) == 1;
%conds = [cond1; cond2];
%[uSol(t), vSol(t)] = dsolve(odes,conds);


rot = eul2rotm([sis_input.bo.RA, -sis_input.bo.Dec, -sis_input.bo.Roll], 'ZYX');

arr = zeros(3,3+3,sis_input.gen.N_bo);

for i = 1:sis_input.gen.N_bo
    omega = [0 , -sis_input.bo.Ang_3(i), sis_input.bo.Ang_2(i) ; sis_input.bo.Ang_3(i) 0 -sis_input.bo.Ang_1(i) ; -sis_input.bo.Ang_2(i) sis_input.bo.Ang_1(i) 0];
    for t = 1:sis_input.gen.N_sub_im
        arr(t,1:3,i) = rotm2eul(rot(:,:,i) - (t/sis_input.gen.N_sub_im) * (omega*rot(:,:,i)));
    end
    
    arr(:,4:6,i) = [cosd(arr(:,2,i)) .* cosd(arr(:,1,i)), cosd(arr(:,2,i)) .* sind(arr(:,1,i)), sind(arr(:,2,i))];
    
end

sis_input.bo = arr;

end

