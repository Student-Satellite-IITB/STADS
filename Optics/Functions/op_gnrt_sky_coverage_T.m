function [op_sky_coverage_T, op_sky_coverage_val] = ...
    op_gnrt_sky_coverage_T(se_bo, se_er, se_ig, se_in, se_op, se_T, op_in)
% Generates the op_sky_coverage_T table which is used to calculate the sky
% coverage value of the system.

    %% Initialize Variables
    % Unpack variables
    v_FOV = op_in.v_FOV;
    op_N_Images = op_in.op_N_Images;
    es_N_TH = op_in.es_N_TH;
    sm_matching_accuracy = op_in.sm_matching_accuracy;
    
    op_sky_coverage_T = array2table(v_FOV); % Create info table

    % Store boreseight vectors in the table
    op_sky_coverage_T.op_r0 = [v_FOV(:,1), v_FOV(:,2), v_FOV(:,3)];
    op_sky_coverage_T = removevars(op_sky_coverage_T, 1:3);

    % Create additional variables to store values within the for loop
    Total_N = zeros(height(v_FOV),1);
    Mean_Sensor_N = zeros(height(v_FOV),1);
    STD_Sensor_N = zeros(height(v_FOV),1);
    Mode_Sensor_N = zeros(height(v_FOV),1);
    Images_N = op_N_Images * ones(height(v_FOV),1);
    Valid_Images_N = zeros(height(v_FOV),1);


    % Store a copy of the se_T variable which is required for each iteration
    % and each image as a fresh copy
    op_T = se_T;

    %% Calculate Sky Coverage
    % !!! Note: Run the code by first setting the range of `idx` from 1:10 !!!
    % 1. Do the above step *atleast four* times till the code becomes
    % optimized by MATLAB and the Elapsed time converges!
    % 2. The code can then be run on the entire sky_coverage table
    %
    % 10 iterations ~ 2.2 s 1100 iterations ~ (2.2 s) X 110 = 3.3 min 
    % (Speedup of ~5x, compared to regular for-loop)
    
    if op_in.iter == -1
        n_iter = height(op_sky_coverage_T);
    else
        n_iter = op_in.iter;
    end

    tic
    parfor idx = 1:n_iter  
        %% Iterate through each boresight vector
        fprintf('idx = %d\n', idx); % Print iteration number 

        % Extract the cartesian vectors from info table
        se_r0 = table2array(op_sky_coverage_T(idx,:));

        % Calculate RA-DE from Cartesian Vectors
        [RA, Dec] = ca_CartVect_2_RA_DE(se_r0(2), se_r0(2), se_r0(3));
        Roll = 0; % Set a junk value for roll

        % Create a template for the input table required by the sensor model
        % code
        input_T = table(RA, Dec, Roll, se_r0);    

        % Create a dummy variable to store the array of number of stars seen in
        % each image
        op_Sensor_N = zeros(op_N_Images, 1);

        % Initialise the variable se_T_FOV with the original se_T
        se_T_FOV = op_T;

        % Run sensor model code
        se_T_FOV = se_PR_1_Trim2FOV(se_T_FOV, input_T, se_op, se_in);

        %Store the total number of stars in the circular FOV
        Total_N(idx) = height(se_T_FOV);

        for jdx = 1:op_N_Images 
            %% Iterate through each image for different angles of roll

            % Calculate the roll angle (deg) as function of the image number
            Roll = jdx * (360/op_N_Images);

            % Create a template for the input table required by the sensor
            % model code
            input_T = table(RA, Dec, Roll, se_r0);

            % Initialise the variable se_T with se_T_FOV since se_T changes for
            % every image
            se_T = se_T_FOV;

            % Run sensor model code
            se_T = se_PR_2a_ICRS2Lens(se_T, input_T, se_in);        
            se_T = se_PR_3_Lens2Sensor(se_T, se_op, se_in);        
            se_T = se_PR_4_Trim2Sensor(se_T, se_op, se_in);

            % Store the number of stars expected in the final image
            op_Sensor_N(jdx) =  height(se_T);
        end

        % Store statistical values of the array op_Sensor_N for further
        % processing
        Mean_Sensor_N(idx) = mean(op_Sensor_N);
        STD_Sensor_N(idx) = std(op_Sensor_N);
        Mode_Sensor_N(idx) = mode(op_Sensor_N);

        N = es_N_TH / (sm_matching_accuracy/100);
        Valid_Images_N(idx) = sum( op_Sensor_N >= N );
    end
    toc

    % Add the arrays to the table
    op_sky_coverage_T.Total_N = Total_N;
    op_sky_coverage_T.Mean_Sensor_N = Mean_Sensor_N;
    op_sky_coverage_T.STD_Sensor_N = STD_Sensor_N;
    op_sky_coverage_T.Mode_Sensor_N = Mode_Sensor_N;
    op_sky_coverage_T.Images_N = Images_N;
    op_sky_coverage_T.Valid_Images_N = Valid_Images_N;

    %% Calculate Sky Coverage
    op_sky_coverage_val = ...
        sum(op_sky_coverage_T.Valid_Images_N)*100/sum(op_sky_coverage_T.Images_N);
end