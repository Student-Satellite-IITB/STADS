function sis_output = sis_main(sis_input, SIS_const, sis_pp_output, version)
% Main function that runs the Star Image Simulation block

%% Code
     if version == "Default Block" 
        %% Unpack variables
        se_T = sis_pp_output.sis_SKY2000;
        se_ig = SIS_const.ig;
        se_in = SIS_const.in;
        se_op = SIS_const.op;
        
        % Attitude
        %se_boresight_inputs_mat = readmatrix('se_boresight_inputs.xlsx','Range', strcat('B2:D', num2str(SIS_const.in.No_Boresight_Inputs + 1)));
        se_bo = array2table(sis_input.attitude, "VariableNames", ["RA", "Dec", "Roll"]);
        se_bo.se_r0 = [cosd(se_bo.Dec) .* cosd(se_bo.RA), cosd(se_bo.Dec) .* sind(se_bo.RA), sind(se_bo.Dec)];

        %% Default Block        
        se_T = se_PR_1_Trim2FOV(se_T, se_bo, se_op, se_in);
        se_T = se_PR_2a_ICRS2Lens(se_T, se_bo, se_in);
        se_T = se_PR_3_Lens2Sensor(se_T, se_op, se_in);
        se_T = se_PR_4_Trim2Sensor(se_T, se_op, se_in);
        sis_Image_Mat = se_PR_5_Image_Generation(se_T, se_op, se_ig, se_in);
        
        %% Save Output
        sis_output.attitude = sis_input.attitude;
        sis_output.image = sis_Image_Mat;
        sis_output.data_table = se_T;    
        sis_output.status = "Done";
        
        
    elseif version == "Version - 3"
        Code here
    end    
end
