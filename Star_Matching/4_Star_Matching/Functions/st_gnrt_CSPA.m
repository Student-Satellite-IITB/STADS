function  [st_CSPA, st_INDEX] = st_gnrt_CSPA(st_AngDst, st_consts_4SM, st_RF_SC)           
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
    % st_AngDst: (Float)
    %     The angular distance calculated between two stars ( in $\cos(\theta)$ )
    % st_consts_4SM:
    % st_RF_SC: ( (st_n_RC, 3) - Matrix )
    %     The Reference Star Catalogue, which has the following columns:
    %     SSP_ID_1 , SSP_ID_2 , K_Vec
    % Returns: 
    % --------
    % st_CSPA: ( (X,1) - Matrix )
    %     The possible SSP-ID matches for given angular distance
    % st_INDEX: ( (1,2) - Matrix )
    %     The start and stop indices of possible matches generated for given angular distance
    %% Calculate constants
    K_Vec = st_RF_SC(:, 3); % Extract K-Vector from Reference catalogue    
 
    % Upack constants
    st_DELTA = st_consts_4SM.st_DELTA;
    st_Q = st_consts_4SM.st_Q;
    st_M = st_consts_4SM.st_M;
    st_n_RC = st_consts_4SM.st_n_RC;
    
    % Calculate sin(theta) value of the given angular distance 
    tmp = sqrt( 1- st_AngDst^2 );
    
    k_bot = floor( (st_AngDst*cos(st_DELTA) - tmp*sin(st_DELTA) - st_Q) / st_M ); % Lower value
    k_top = ceil( (st_AngDst*cos(st_DELTA) + tmp*sin(st_DELTA) - st_Q) / st_M ); % Upper value

    if (k_top <= 0) || (k_bot >= st_n_RC) 
        fprintf('Wrong Indices:  %d,   %d | AngDst: %d \n', k_bot, k_top, st_AngDst);
        st_CSPA = [];
        st_INDEX = [];  
    else
        if (k_top > st_n_RC)
            fprintf('Reset k_top: %d, %d | AngDst: %d \n', k_bot, k_top, st_AngDst);
            k_top = st_n_RC;
        end
        if (k_bot <= 0)
            fprintf('Reset k_bot: %d, %d | AngDst: %d \n', k_bot, k_top, st_AngDst);
            k_bot = 1;
        end

        start = K_Vec(k_bot) + 1; % Lower index
        stop = K_Vec(k_top); % Upper index
        st_INDEX = [start, stop]; % Generate INDEX

        %% Generate Candidate Star Pair Array
        if (start == stop) % Case - 1        
            SSP_ID = st_RF_SC(stop, 1:2); % Extract SSP IDs        

        else % Case - 2        
            SSP_ID = st_RF_SC(start:stop, 1:2); % Extract SSP IDs
        end

        st_CSPA = reshape(SSP_ID,[], 1); % Store SSP IDs in CSPA column matrix
    end
end