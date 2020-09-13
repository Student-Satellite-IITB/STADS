function [N_Verified, sm_Verified, N_Failed, sm_Failed] = ...
    sm_verify_4SM(sm_Matched, N_Matched, SM_const, sm_PP_LIS_output)
    % Performs the verification step for 4-Star Matching Algorithm. It
    % assigns votes to the matched stars that get verified. 
    % Returns only those stars which have 100% votes
    % Parameters:
    % -----------
    % st_Match : ( (st_N_Match, 5) - Matrix )
    %   This matrix contains the entries of the stars that have been 
    %   matched so far. The columns are as follows:
    %   $1^{st}$ column - Feature Extraction ID
    %   $2^{nd}, 3^{rd}, 4^{th}$ columns - $(X, Y, Z)$ unit body-frame 
    %   vector
    %   $5^{th}$ column - The matched SSP-ID
    % st_N_Match : Integer
    %   Number of matched stars in st_Match matrix
    % st_GD_SC: ( (n_rw_GC, 4) - Matrix )
    %   The Guide catalogue, which has the following columns:
    %   SSP_ID , X , Y , Z
    % st_verify_tol : (Double)
    %   The tolerance within which the angular distance (in $cos(\theta)$) 
    %   of a pair of image stars should have match with the corresponding 
    %   pair of stars from the Star Catalogue. Units - in percentage 
    % Returns:
    % --------
    % st_N_Verify: (Integer)
    %   Number of stars that passed the verification  step
    % st_Verify : ( (st_N_verify, 6) - Matrix )
    %   This matrix contains the entries of the stars that have been 
    %   verified. The columns are as follows:
    %   $1^{st}$ column - Feature Extraction ID
    %   $2^{nd}, 3^{rd}, 4^{th}$ columns - $(X, Y, Z)$ unit body-frame 
    %   vector
    %   $5^{th}$ column - The matched SSP-ID
    %   $6^{th}$ column - Number of votes
    % st_N_fail: (Integer)
    %   Number of stars that failed the verification  step
    % st_Fail : ( (st_N_Fail_, 6) - Matrix )
    %   This matrix contains the entries of the stars that failed the
    %   verification step. The columns are as follows:
    %   $1^{st}$ column - Feature Extraction ID
    %   $2^{nd}, 3^{rd}, 4^{th}$ columns - $(X, Y, Z)$ unit body-frame 
    %   vector
    %   $5^{th}$ column - The matched SSP-ID
    %   $6^{th}$ column - Number of votes   
    
    %% Code
    N = N_Matched;
    
    % Initialize matrix
    sm_Verified = sm_Matched;
    sm_Verified.Num_Votes = zeros(N, 1);
    
    %% Verification Step
    for i_idx = 1 : N-1
        
        ssp_id1 = sm_Verified.SSP_ID(i_idx); % Assign SSP ID   
        ri_1 = sm_PP_LIS_output.CONST_4SM.sm_GD_SC(ssp_id1, {'X', 'Y', 'Z'}); % Assign Inertial-frame vector
        bi_1 = sm_Verified(i_idx, {'X', 'Y', 'Z'}); % Assign Body-frame vector
        
        ri_1 = table2array(ri_1); bi_1 = table2array(bi_1);
        
        for j_idx = i_idx : N
        
            ssp_id2 = sm_Verified.SSP_ID(j_idx); % Assign SSP ID
            ri_2 = sm_PP_LIS_output.CONST_4SM.sm_GD_SC(ssp_id2, {'X', 'Y', 'Z'}); % Assign Inertial-frame vector
            bi_2 = sm_Verified(j_idx, {'X', 'Y', 'Z'}); % Assign Body-frame vector
            
            ri_2 = table2array(ri_2); bi_2 = table2array(bi_2);            
            
            % Calculate dot products
            dot_bi = dot(bi_1, bi_2);
            dot_ri = dot(ri_1, ri_2);
                       
            err = abs(dot_bi/dot_ri - 1)*100;
            if err <= SM_const.LIS.CONST_4SM.VERIFY_TOL
                % Increment Votes
                sm_Verified.Num_Votes(i_idx) = sm_Verified.Num_Votes(i_idx) + 1;
                sm_Verified.Num_Votes(j_idx) = sm_Verified.Num_Votes(j_idx) + 1;
            end
        end
    end
    
    %% Remove failed stars    
    sm_verify_lower_bound = 35/100;
    sm_verify_upper_bound = 80/100;
    
    N_lb = ceil(N * sm_verify_lower_bound);
    bool_check_1 = sm_Verified.Num_Votes(:)<= N_lb;
    
    N_ub = floor( ( N - sum(bool_check_1) ) * sm_verify_upper_bound );
    bool_check_2 = sm_Verified.Num_Votes(:) >= N_ub;
    
    bool_idx = ~bool_check_1 & bool_check_2;
    
    %%
    N_Failed = sum(~bool_idx);
    sm_Failed = sm_Verified(~bool_idx, :);
    
    N_Verified = sum(bool_idx);
    sm_Verified = sm_Verified(bool_idx, :);    
    
end