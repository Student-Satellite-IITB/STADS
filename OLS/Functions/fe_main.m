function [fe_output, SM_const] = fe_main(sis_output, FE_const, SM_const, algo)
% Main function that runs the Feature Extraction block

%% Code

    if algo == "Default Block"        
        cond = sis_output.data_table.Magnitude <= SM_const.MAG_LIMIT;
        fe_output.centroids = sis_output.data_table(cond,{'SSP_ID', 'Sensor_y','Sensor_z'});
        fe_output.centroids.Properties.VariableNames={'FE_ID','X','Y'};
        fe_output.N = height(fe_output.centroids);
        for i = 1:fe_output.N
            fe_output.centroids.FE_ID(i) = i;
        end
        fe_output.status = "Done";
        
        % Update the value of DELTA, since by using the "Default Block" of
        % Feature Extraction, there is no error in the centroids of the
        % stars
        SM_const.LIS.CONST_4SM.DELTA = 0.01e-4;
        
    elseif algo == "Region Growth"
        line_ans = fe_region_growth(sis_output,FE_const);
        fe_output.centroids.FE_ID = line_ans(:, 1);
        fe_output.centroids.X = line_ans(:, 2);
        fe_output.centroids.Y = line_ans(:, 3);
        fe_output.N = length(fe_output.centroids.FE_ID); % The units of the centroids need to be in (mm) make sure of that, else SM-LIS won't work
        fe_output.status = "Done";
        
    elseif algo == "Tagging"
        line_ans = fe_centroiding_2(sis_output, FE_const);
        fe_output.centroids.FE_ID = line_ans(:, 1);
        fe_output.centroids.X = line_ans(:, 2); % TODO change this
        fe_output.centroids.Y = line_ans(:, 3);
        %fe_output.N = line_ans(2);
        fe_output.N = length(line_ans);
        fe_output.status = "Done";
        
        
    elseif algo == "Line-by-Line"
        % This function file is not yet finalized/free of errors
        %line_ans = fe_centroiding_rle(sis_output);
        %fe_output.centroids = line_ans(1);
        %fe_output.N = line_ans(2);
        %fe_output.status = "Done";
   end    
end
