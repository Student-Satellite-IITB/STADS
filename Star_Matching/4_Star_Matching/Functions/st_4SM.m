function [st_n_match, st_result] = st_4SM(st_4SM_input, st_consts_4SM, st_catalogues)
    % This function runs the 4-Star Matching Algorithm on four-stars only. 
    % It executes the algorithm to match stars, and returns the result.
    % Parameters:
    % -----------
    % st_4SM_input: ( (4, 4) - Matrix )
    %   The input to 4-Star Matching Algorithm - four stars identified by
    %   Feature Extraction, along with their body-frame vectors. It is a 
    %   unit-vector represented in $(X,Y,Z)$ format, with the origin at the 
    %   center of the sensor and positive z-axis pointing out of the lens. 
    %   The first column corresponds to the Feature Extraction ID of the
    %   star.
    % st_consts_4SM:
    % st_catalogues:
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
    
    % Caluculate Star Identification Matrix
    st_SIM = st_gnrt_SIM(st_c_img_AngDst, st_catalogues.st_RF_SC, st_consts_4SM); 

    % Evaluate SIM to find the Star Matched Matrix
    [st_SMM, ~]  = st_gnrt_SMM(st_SIM, st_consts_4SM.st_n_GC, st_c_fe_ID);
    
    %% Output
    idx_match = find( st_SMM(:,2) ); % Indices of matched stars
    st_n_match = length(idx_match); % Number of matched stars
    st_result = st_SMM(:, 1:2); % Final Output
end