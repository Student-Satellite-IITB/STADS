function sis_T = sis_light_main(sis_T,sis_bo, sis_input)
    %% Trim to FOV
    
    sis_bo = array2table(sis_bo, "VariableNames", ["RA", "Dec", "Roll", "sis_r0_1", "sis_r0_2", "sis_r0_3"]);
    % Add the broadcasted boresight input to the table
    sis_T = [sis_T repmat(sis_bo(1,4:6), size(sis_T.RA))];

    % Add the Angular_Distance Column using the function sis_ang_dist
    sis_T = [sis_T rowfun(@sis_ang_dist, sis_T, 'InputVariables', {'sis_r0_1', 'sis_r0_2', 'sis_r0_3', 'r0'}, 'OutputVariableName', 'Angular_Distance')];
    sis_T = removevars(sis_T, {'sis_r0_1', 'sis_r0_2', 'sis_r0_3'});
    if (sis_input.gen.Debug_Run == 1); disp('Trim to FOV: Angular Distances Added'); end

    % Retain only the stars with Angular Distance less than FOV
    %%%% When is this Angular_Distance thing added to sis_T ??
    sis_T = sis_T(sis_T.Angular_Distance <= sis_input.lls.FOV.Circular / 2, :);
    if (sis_input.gen.Debug_Run == 1); disp('Trim to FOV: Trimmed to FOV'); end

    
    % Display Sucess
    if (sis_input.gen.Debug_Run == 1); fprintf('Trim to FOV: Success \n \n'); end
    
    
    
    
    %% ICRS to Lens Frame
    
    
    
    % Define Rotation Matrices
    sis_Rx = [1 0 0; 0 cosd(sis_bo.Roll) -sind(sis_bo.Roll); 0 sind(sis_bo.Roll) cosd(sis_bo.Roll)];
    sis_Ry = [cosd(sis_bo.Dec) 0 sind(sis_bo.Dec); 0 1 0; -sind(sis_bo.Dec) 0 cosd(sis_bo.Dec)];
    sis_Rz = [cosd(sis_bo.RA) -sind(sis_bo.RA) 0; sind(sis_bo.RA) cosd(sis_bo.RA) 0; 0 0 1];

    % Perform 1st rotation
    sis_T.r1 = sis_T.r0 * sis_Rz;
    if (sis_input.gen.Debug_Run == 1); disp('ICRS to Lens: 1st Euler Rotation Performed'); end

    % Perform 2nd rotation
    sis_T.r2 = sis_T.r1 * sis_Ry';
    if (sis_input.gen.Debug_Run == 1); disp('ICRS to Lens: 2nd Euler Rotation Performed'); end

    % Perform 3rd rotation
    sis_T.r3 = sis_T.r2 * sis_Rx';
    if (sis_input.gen.Debug_Run == 1); disp('ICRS to Lens: 3rd Euler Rotation Performed'); end

    % Display Sucess
    if (sis_input.gen.Debug_Run == 1); fprintf('ICRS to Lens: Success \n \n'); end


end


function ang_dist = sis_ang_dist(sis_r0_1, sis_r0_2, sis_r0_3, r0)
    %% 
    % Calculates the Angular Distance
    % This function calculates the Angular Distance between 2 vectors.
    sis_r0 = [sis_r0_1, sis_r0_2, sis_r0_3];
    
    ang_dist = rad2deg(atan2(norm(cross(sis_r0,r0)), dot(sis_r0,r0)));
end


