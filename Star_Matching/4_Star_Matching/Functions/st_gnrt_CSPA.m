function  [CSPA, INDEX] = st_gnrt_CSPA(str_AngDst, st_DELTA, st_M, st_Q, st_RF_SC)           
    % Generates the candidate star pair array (CSPA) from the value of 
    % angular distance calculated between two image stars
    % Reference:
    % ----------
    % Refer 2. 4-Star Matching Strategy' - Dong, Ying & Xing, Fei & You, 
    % Zheng. (2006). Brightness Independent 4_Star Matching Algorithm for 
    % Lost-in-Space 3-Axis Attitude Acquisition. Tsinghua Science & 
    % Technology. 11. 543-548. 10.1016/S1007-0214(06)70232-2. 
    % Parameters:
    % -----------
    % str_AngDst: (Float)
    %     The angular distance calculated between two stars ( in $\cos(\theta)$ )
    % st_DELTA: (Float)
    %   The $\delta$ constant that determines the tolerance of the size 
    %   window when searching for an angular distance value in the 
    %   Reference Star Catalogue
    % st_M: (Float)
    %   The slope of the Z-vector line
    % st_Q: (Float)
    %   The y-intercept of the Z-vector line
    % st_RF_SC: ( (n_rw_RC, 3) - Matrix )
    %     The Reference Star Catalogue, which has the following columns:
    %     SSP_ID_1 , SSP_ID_2 , K_Vec
    % Returns: 
    % --------
    % CSPA: ( (X,1) - Matrix )
    %     The possible SSP-ID matches for given angular distance
    % INDEX: ( (1,2) - Matrix )
    %     The start and stop indices of possible matches generated for given angular distance
    %% Calculate constants
    K_Vec = st_RF_SC(:, 3); % Extract K-Vector from Reference catalogue
    
    % Calculate sin(theta) value of the given angular distance 
    tmp = sqrt( 1- str_AngDst^2 ); 
    
    k_bot = floor( (str_AngDst*cos(st_DELTA) - tmp*sin(st_DELTA) - st_Q) / st_M ); % Lower value
    k_top = ceil( (str_AngDst*cos(st_DELTA) + tmp*sin(st_DELTA) - st_Q) / st_M ); % Upper value

    start = K_Vec(k_bot) + 1; % Lower index
    stop = K_Vec(k_top); % Upper index
    INDEX = [start, stop]; % Generate INDEX
    
    %% Generate Candidate Star Pair Array
    if (start == stop) % Case - 1        
        SSP_IDs = st_RF_SC(stop, 1:2); % Extract SSP IDs        

    else % Case - 2        
        SSP_IDs = st_RF_SC(start:stop, 1:2); % Extract SSP IDs
    end
    
    CSPA = reshape(SSP_IDs,[], 1); % Store SSP IDs in CSPA column matrix
end