function [st_n_match, st_result] = st_4SM(st_4SM_input, st_RF_SC, st_4SM_constants)
    % This function runs the 4-Star Matching Algorithm. It executes the
    % algorithm to match stars, and returns the result.
    % Parameters:
    % -----------
    % st_4SM_input: ( (4, 4) - Matrix )
    %   The input to 4-Star Matching Algorithm - four stars identified by
    %   Feature Extraction, along with their body-frame vectors. It is a 
    %   unit-vector represented in $(X,Y,Z)$ format, with the origin at the 
    %   center of the sensor and positive z-axis pointing out of the lens. 
    %   The first column corresponds to the Feature Extraction ID of the
    %   star.
    % st_RF_SC: ( (st_n_RC, 3) - Matrix )
    %   The Reference catalogue, which has the following columns:
    %   SSP_ID_1 - The SSP-ID of $i^{th}$ star
    %   SSP_ID_2 - The SSP-ID of $j^{th}$ star
    %   K_Vec - he K-Vector value determined uniquely using the dot product
    %   of the Cartesian unit vector corresponding to the $i^{th}$ and 
    %   $j^{th}$ star $(i \ne j,  \forall$ $i, j)$
    % st_4SM_constants: ( (4, 1) - Matrix )
    %   An array that constains the following constants:
    %   [st_n_GC, st_M, st_Q, st_DELTA]
    % Returns:
    % --------
    % st_n_match : (Integer)
    %   The number of stars that have been matched
    % st_result : ( (4,2) - Matrix )
    %   Output of 4-Star Matching. The  columns of the matrix are as 
    %   follows:
    %   $1^{st}$ column - Feature Extraction ID
    %   $2^{nd}$ column - The matched SSP-ID (If no match was made - $0$ 
    %   is assigned)
    
    %% Code
    
    % Generate input in the format required by 4-Star Matching Algorithm
    [st_c_img_AngDst, st_c_fe_ID] = st_gnrt_ip_4SM(st_4SM_input);
  
    % Upack constants
    st_n_GC = st_4SM_constants(1);
    
    % Caluculate Star Identification Matrix
    st_SIM = st_gnrt_SIM(st_c_img_AngDst, st_RF_SC, st_4SM_constants); 

    % Evaluate SIM to find the Star Matched Matrix
    [st_SMM, ~]  = st_gnrt_SMM(st_SIM, st_n_GC, st_c_fe_ID);
    
    %% Output
    idx_match = find( st_SMM(:,2) ); % Indices of matched stars
    st_n_match = length(idx_match); % Number of matched stars
    st_result = st_SMM(:, 1:2); % Final Output

end
