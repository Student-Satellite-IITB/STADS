function [sm_n_match, sm_result] = sm_4SM(sm_4SM_input, SM_const, sm_PP_LIS_output)
    % This function runs the 4-Star Matching Algorithm on four-stars only. 
    % It executes the algorithm to match stars, and returns the result.
    % Parameters:
    % -----------
    % st_4SM_input: ------
    % st_consts_4SM: ------
    % st_catalogues: ------
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
    [sm_c_img_AngDst, sm_c_fe_ID] = sm_gnrt_ip_4SM(sm_4SM_input);
    
    % Caluculate Star Identification Matrix
    sm_SIM = sm_gnrt_SIM(sm_c_img_AngDst, SM_const, sm_PP_LIS_output); 

    % Evaluate SIM to find the Star Matched Matrix
    [sm_SMM, ~]  = sm_gnrt_SMM(sm_SIM, sm_c_fe_ID, sm_PP_LIS_output);
    
    %% Output
    idx_match = find( sm_SMM.SSP_ID(:) ); % Indices of matched stars
    sm_n_match = length(idx_match); % Number of matched stars
    sm_result = sm_SMM(:, 1:2); % Final Output
end