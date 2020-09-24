function [sm_Matched, sm_NotMatched, sm_N_Matched, sm_N_NotMatched] = ...
    sm_update_match_matrix( ...
    sm_result, sm_Matched, sm_NotMatched, sm_N_Matched, sm_N_NotMatched ...
    )
    
    %% Code
    for i = 1:4
        sm_ssp_id = sm_result.FE_ID(i); % Matched SSP-ID
        
        %% Matrix updation
        if sm_ssp_id == 0
            continue;
            
        else
        % Feature Extarction ID of corresponding star
        sm_fe_id = sm_result.FE_ID(i); 

        % Index of row corresponding to the Feature Extarction ID 
        [~, idx] = ismember( sm_fe_id , sm_NotMatched.FE_ID(:) );

        % Append matched row along to Match matrix
        sm_Matched( sm_N_Matched + 1, 1:end-1 ) = sm_NotMatched(idx, :);
        sm_Matched.SSP_ID(sm_N_Matched + 1) = sm_ssp_id;

        % Remove matched star from NotMatched Matrix
        sm_NotMatched(idx, :) = [];

        % Update counter variables
        sm_N_Matched = sm_N_Matched + 1;
        sm_N_NotMatched = sm_N_NotMatched - 1;
        end
    end
end       