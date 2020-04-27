function  [CSPA, INDEX] = sm_gnrt_CSPA(str_AngDst, sm_DELTA, sm_Q, sm_M, sm_RF_SC)           
    % Generates the candidate star pair array (CSPA) from the measured value
    % of the angular distance
    % Reference:
    % ----------
    % Refer 2. 4-Star Matching Startergy' - Dong, Ying & Xing, Fei & You, 
    % Zheng. (2006). Brightness Independent 4_Star Matching Algorithm for 
    % Lost-in-Space 3-Axis Attitude Acquisition. Tsinghua Science & 
    % Technology. 11. 543-548. 10.1016/S1007-0214(06)70232-2. 
    % Parameters:
    % -----------
    % str_AngDst: Float
    %     The angular distance calculated between two stars ( in cos(theta) )
    % sm_DELTA: Float
    %     The value of uncertainty constant to be used to find the range of
    %     angular distances from the Reference catalogue that match with
    %     the given ang_dist
    % sm_Q: Float
    %     Coefficient of Z-Vector line
    % sm_M: Float
    %      Slope of Z-Vector line
    % sm_RF_SC: (N, 3) - Matrix
    %     The Reference catalogue, which has the following columns:
    %     SSP_ID_1 , SSP_ID_2 , K_Vec
    % Returns: 
    % --------
    % CSPA: (N,1) - matrix
    %     The possible SSP_ID matches for given angular distance
    % INDEX: (1,2) - matrix
    %     The start and stop indices of possible matches generated for given angular distance
    %% Calculate constants
    K_Vec = sm_RF_SC(:, 3); % Extract K-Vector from Reference catalogue
    
    % Calculate sin(theta) value of the given angular distance 
    tmp = sqrt( 1- str_AngDst^2 ); 
    
    k_bot = floor( (str_AngDst*cos(sm_DELTA) - tmp*sin(sm_DELTA) - sm_Q) / sm_M ); % Lower value
    k_top = ceil( (str_AngDst*cos(sm_DELTA) + tmp*sin(sm_DELTA) - sm_Q) / sm_M ); % Upper value

    start = K_Vec(k_bot) + 1; % Lower index
    stop = K_Vec(k_top); % Upper index
    INDEX = [start, stop]; % Generate INDEX
    
    %% Generate Candidate Star Pair Array
    if (start == stop) % Case - 1        
        SSP_IDs = sm_RF_SC(stop, 1:2); % Extract SSP IDs        

    else % Case - 2        
        SSP_IDs = sm_RF_SC(start:stop, 1:2); % Extract SSP IDs
    end
    
    CSPA = reshape(SSP_IDs,[], 1); % Store SSP IDs in CSPA column matrix
end