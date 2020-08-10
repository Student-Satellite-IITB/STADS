function [st_N_Verify, st_Verify, st_N_Fail, st_Fail] = ...
    st_verify_4SM(st_Match, st_N_Match, st_GD_SC, st_verify_tol)
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
    N = st_N_Match;
    
    % Initialize matrix
    st_Verify = [st_Match, zeros(N, 1)];
    
    %% Verification Step
    for i_idx = 1 : N-1
        
        ssp_id1 = st_Verify(i_idx, 5); % Assign SSP ID   
        ri_1 = st_GD_SC(ssp_id1, [2,3,4]); % Assign Inertial-frame vector
        bi_1 = st_Verify(i_idx, [2,3,4]); % Assign Body-frame vector
        
        for j_idx = i_idx : N
        
            ssp_id2 = st_Verify(j_idx, 5); % Assign SSP ID
            ri_2 = st_GD_SC(ssp_id2, [2,3,4]); % Assign Inertial-frame vector
            bi_2 = st_Verify(j_idx, [2,3,4]); % Assign Body-frame vector
            
            % Calculate dot products
            dot_bi = dot(bi_1, bi_2);
            dot_ri = dot(ri_1, ri_2);
                       
            err = abs(dot_bi/dot_ri - 1)*100;
            if err <= st_verify_tol
                % Increment Votes
                st_Verify(i_idx, 6) = st_Verify(i_idx, 6) + 1;
                st_Verify(j_idx, 6) = st_Verify(j_idx, 6) + 1;
            end
        end
    end
    
    %% Remove failed stars    
    st_verify_lower_bound = 35/100;
    st_verify_upper_bound = 80/100;
    
    N_lb = ceil(N * st_verify_lower_bound);
    bool_check_1 = st_Verify(:, 6) <= N_lb;
    
    N_ub = floor( ( N - sum(bool_check_1) ) * st_verify_upper_bound );
    bool_check_2 = st_Verify(:, 6) >= N_ub;
    
    bool_idx = ~bool_check_1 & bool_check_2;
    
    %%
    st_N_Fail = sum(~bool_idx);
    st_Fail = st_Verify(~bool_idx, :);
    
    st_N_Verify = sum(bool_idx);
    st_Verify = st_Verify(bool_idx, :);    
    
end