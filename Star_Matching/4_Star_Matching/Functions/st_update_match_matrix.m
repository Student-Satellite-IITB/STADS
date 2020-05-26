function [st_Match, st_UnMatch, st_N_Match, st_N_UnMatch] = ...
st_update_match_matrix(st_result, st_Match, st_UnMatch, st_N_Match, st_N_UnMatch)
    % Updates the Match Matrices associated with 4-Star Matching Algorithm
    % Parameters:
    % -----------
    % st_result : ( (4,2) - Matrix )
    %   Output of 4-Star Matching. The  columns of the matrix are as 
    %   follows:
    %   $1^{st}$ column - Feature Extraction ID
    %   $2^{nd}$ column - The matched SSP-ID (If no match was made - $0$ 
    %   is assigned)
    % st_Match : ( (st_N_Match, 5) - Matrix )
    %   This matrix contains the entries of the stars that have been 
    %   matched so far. The columns are as follows:
    %   $1^{st}$ column - Feature Extraction ID
    %   $2^{nd}, 3^{rd}, 4^{th}$ columns - $(X, Y, Z)$ unit body-frame 
    %   vector
    %   $5^{th}$ column - The matched SSP-ID
    % st_UnMatch : ( (st_N_UnMatch, 4) - Matrix )
    %   This matrix contains the entries of the stars that are yet to be 
    %   $1^{st}$ column - Feature Extraction ID
    %   $2^{nd}, 3^{rd}, 4^{th}$ columns - $(X, Y, Z)$ unit body-frame 
    %   vector
    % st_N_Match : Integer
    %   Number of matched stars in st_Match matrix
    % st_N_NonMatch : Integer
    %   Number of stars yet to be matched in st_UnMatch matrix
    % Returns:
    % --------
    % st_Match : ( (fe_n_str, 5) - Matrix )
    %   Updated value of matrix
    % st_UnMatch : ( (fe_n_str, 4) - Matrix )
    %   Updated value of matrix
    % st_N_Match : Integer
    %   Updated value of counter variable
    % st_N_NonMatch : Integer
    %   Updated value of counter variable
    
    %% Code
    for i = 1:4
        st_ssp_id = st_result(i, 2); % Matched SSP-ID
        
        %% Matrix updation
        if st_ssp_id == 0
            continue;
            
        else
        % Feature Extarction ID of corresponding star
        st_fe_id = st_result(i, 1); 

        % Index of row corresponding to the Feature Extarction ID 
        [~, idx] = ismember( st_fe_id , st_UnMatch(:, 1) );

        % Append matched row along to Match matrix
        st_Match( st_N_Match + 1 , : ) = [st_UnMatch(idx, :), st_ssp_id];

        % Remove matched star from UnMatch Matrix
        st_UnMatch(idx, :) = [];

        % Update counter variables
        st_N_Match = st_N_Match + 1;
        st_N_UnMatch = st_N_UnMatch - 1;
        end
    end
end       