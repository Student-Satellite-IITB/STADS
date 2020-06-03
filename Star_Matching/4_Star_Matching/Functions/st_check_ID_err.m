function st_flag_ID_err = st_check_ID_err(st_result, st_ref_ID, st_N)
    % Evaluates the result of Star-Matching with one of the input stars 
    % having already been matched, and checks for discrepancy error (if 
    % any) in the previously matched SSP-ID, and newly generated SSP-ID
    % Parameters:
    % -----------
    % st_result : ( (4,2) - Matrix )
    %   Output of 4-Star Matching. The  columns of the matrix are as 
    %   follows:
    %   $1^{st}$ column - Feature Extraction ID
    %   $2^{nd}$ column - The matched SSP-ID (If no match was made - $0$ 
    %   is assigned)
    % st_ref_ID : ( (4,2) - Matrix )
    %   This matrix is stores the previously matched SSP-IDs of the stars 
    %   taken from st_Match matrix. This is used to check if the newly 
    %   matched SSP-ID is the same as the previous SSP-ID. The columns of 
    %   this matrix are as follows:
    %   $1^{st}$ column - Feature Extraction ID
    %   $2^{nd}$ column - The previously matched SSP-ID (The unmatched 
    %   stars have $0$ as their ID)
    % st_N : (Integer)
    %   Number of previously matched stars used as input
    % Returns:
    % --------
    % st_flag_ID_err: (boolean)
    %   Returns 1 if the previous and the new SSP-ID do not match, or if
    %   the previously matched star was not matched in st_result.
    %   Returns 0 only if they match!
    
    %% Code
    
    st_flag_ID_err = boolean(0); % Initialize flag variable
    
   
    for i = 1:st_N
        st_fe_id = st_ref_ID(i, 1); % Feature Extraction ID of the star
        st_ssp_id = st_ref_ID(i, 2); % Matched SSP-ID of the star
        
        % Index of row corresponding to the Feature Extarction ID 
        [~, idx] = ismember( st_fe_id , st_result(:, 1) );
        
        st_new_ssp_id = st_result(idx, 2); % Newly matched SSP-ID of the star
        
        if (st_new_ssp_id == 0) || (st_new_ssp_id ~= st_ssp_id)
            % Update flag variable
            st_flag_ID_err = boolean(1);
        end
    end
end