function  [sm_CSPA, sm_INDEX] = sm_gnrt_CSPA(sm_AngDst, SM_const, sm_PP_LIS_output)           
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
    % st_consts_4SM:

    % Returns: 
    % --------
    % st_CSPA: ( (X,1) - Matrix )
    %     The possible SSP-ID matches for given angular distance
    % st_INDEX: ( (1,2) - Matrix )
    %     The start and stop indices of possible matches generated for given angular distance
    %% Calculate constants
    K_Vec = sm_PP_LIS_output.CONST_4SM.sm_RF_SC.K_Vec; % Extract K-Vector from Reference catalogue    
 
    % Upack constants
    sm_DELTA = SM_const.LIS.CONST_4SM.DELTA;
    sm_Q = sm_PP_LIS_output.CONST_4SM.sm_Q;
    sm_M = sm_PP_LIS_output.CONST_4SM.sm_M;
    sm_n_RC = sm_PP_LIS_output.CONST_4SM.sm_n_RC;%no. of reference star pairsa 
    
    % Calculate sin(theta) value of the given angular distance 
    tmp = sqrt( 1- sm_AngDst^2 );
    
    k_bot = floor( (sm_AngDst*cos(sm_DELTA) - tmp*sin(sm_DELTA) - sm_Q) / sm_M ); % Lower value
    k_top = ceil( (sm_AngDst*cos(sm_DELTA) + tmp*sin(sm_DELTA) - sm_Q) / sm_M ); % Upper value

    if (k_top <= 0) || (k_bot >= sm_n_RC) 
        fprintf('Wrong Indices:  %d,   %d | AngDst: %d \n', k_bot, k_top, sm_AngDst);
        sm_CSPA = [];
        sm_INDEX = [];  
    else
        if (k_top > sm_n_RC)
            fprintf('Reset k_top: %d, %d | AngDst: %d \n', k_bot, k_top, sm_AngDst);
            k_top = sm_n_RC;
        end
        if (k_bot <= 0)
            fprintf('Reset k_bot: %d, %d | AngDst: %d \n', k_bot, k_top, sm_AngDst);
            k_bot = 1;
        end

        start = K_Vec(k_bot) + 1; % Lower index
        stop = K_Vec(k_top); % Upper index
        sm_INDEX = [start, stop]; % Generate INDEX

        %% Generate Candidate Star Pair Array
        if (start == stop) % Case - 1        
            SSP_ID = sm_PP_LIS_output.CONST_4SM.sm_RF_SC(stop, 1:2); % Extract SSP IDs        

        else % Case - 2        
            SSP_ID = sm_PP_LIS_output.CONST_4SM.sm_RF_SC(start:stop, 1:2); % Extract SSP IDs
        end
        
        sm_CSPA = reshape(table2array(SSP_ID),[], 1); % Store SSP IDs in CSPA column matrix
    end
end