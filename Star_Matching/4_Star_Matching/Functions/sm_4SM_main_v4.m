function [sm_output] = sm_4SM_main_v4(fe_output, SM_const, sm_PP_LIS_output)
    
    %% Code

    % Generate body-frame vectors of stars 

    sm_bi = sm_gnrt_bi(fe_output, SM_const); 
    
    %% 4-Star Matching Alogorithm

    % Initialize sm_Matched
    sm_Matched = array2table( ...
        zeros(fe_output.N, 5), 'VariableNames', ...
        {'FE_ID', 'X', 'Y', 'Z', 'SSP_ID'} ...
    );

    % Set sm_Matched Table properties
    sm_Matched.Properties.VariableUnits = {'', 'mm', 'mm', 'mm', ''};
    sm_Matched.Properties.VariableDescriptions = { ...
        'Feature Extraction - Star ID', 'Body-frame vector: X component', ...
        'Body-frame vector: Y component', 'Body-frame vector: Z component', ...
        'Matched SSP ID' ...
    };

    % Initialize sm_NotMatched
    sm_NotMatched = sm_bi;
    % Intialize counter variables
    sm_counter.N_Matched = 0; % Number of matched stars
    sm_counter.N_NotMatched = fe_output.N; % Number of unmatched stars
    %%
    sm_counter.flag_circshift = 0;
    for i_iter = 1:SM_const.LIS.CONST_4SM.ITER_MAX 
        % Total number of iterations allowed for Star-Matching
        sm_counter.iter = i_iter;
        if (sm_counter.N_NotMatched >= 4) && (sm_counter.N_Matched < SM_const.N_TH)
            % Extract first four stars from NotMatched table
            sm_4SM_input = sm_NotMatched(1:4, :); 

            % Run 4-Star Matching Alogrithm on 4 Stars
            [sm_N_match, sm_result] = sm_4SM(sm_4SM_input, SM_const, sm_PP_LIS_output);

            if sm_N_match == 0 
                % If no stars were matched, shift the rows of Non_Match matrix
                % downward by one unit
                sz = size(sm_NotMatched,1);
                if sz>=5
                    temp = sm_NotMatched(1,:);
                    for i=1:sz-1
                        sm_NotMatched(i,:) = sm_NotMatched(i+1,:);
                    end
                    sm_NotMatched(sz,:) = temp;
                end
                	

                sm_counter.flag_circshift = sm_counter.flag_circshift + 1; % Update flag

                if sm_counter.flag_circshift == fe_output.N 
                    % If circshift has been performed fe_n_str times, it is
                    % periodic. Thus break the Star-Matching iteration to
                    % prevent redundant periodic computation
                    disp('Error: flag_circshift!');
                    break;
                end

            else
                % Update Match Matrices
                [sm_Matched, sm_NotMatched, sm_counter.N_Matched, sm_counter.N_NotMatched] = ...
                sm_update_match_matrix(sm_result, sm_Matched, sm_NotMatched, sm_counter.N_Matched, sm_counter.N_NotMatched);
                disp(sm_NotMatched);
            end

        elseif (sm_counter.N_Matched >= SM_const.N_TH) || (sm_counter.N_NotMatched == 0)
            % If all the numbers of stars matched exceed es_N_EST, or there are
            % no more stars to be matched, break out of Star-Matching 
            % interation
            break;

    %%%%%%%%%%%%% THIS SECTION IS CURRENTLY UNDER DEVELOPMENT!
    %%%%%%%%%%%%% DO NOT <<< UNCOMMENT >>> IT!
    %     elseif (st_N_UnMatch < 4) && (st_N_Match + st_N_UnMatch >= 4)
    %         % If there are unmatched stars less than 4 in mumber, we borrow
    %         % stars which have already been matched to create an array of 4
    %         % stars, and proceed with Star-Matching
    %         
    %         % NOTE: If the stars that had been matched are matched again in
    %         % this new itertation, but the matched SSP-IDs do not match, we
    %         % ignore this entire iteration
    %         
    %         % Number of stars needed from Match Matrix to run 4-Star Matching
    %         % Algorithm
    %         st_N = 4 - st_N_UnMatch; 
    %         
    %         tmp1 = st_Match(1:st_N, 1:4); % Extract first N rows from Match Matrix
    %         tmp2 = st_UnMatch(1:4-st_N, :); % Extract first (4-N) rows from UnMatch Matrix
    %         
    %         tmp3 = st_Match(1:st_N, 5); % Previoulsy matched SSP-IDs
    %         
    %         % Shift the rows of Match matrix downward by N units
    %         st_Match = circshift(st_Match, [st_N,0]);
    %         
    %         % Generate Input
    %         st_4SM_input = [tmp1; tmp2];
    %         
    %         % Generate st_ref_ID
    %         st_ref_ID = zeros(4,2); % Initalize zero-matrix
    %         st_ref_ID(:, 1) = st_4SM_input(:, 1); % Append Feature Extraction IDs
    %         st_ref_ID(1:st_N, 2) = tmp3; % Append previoulsy matched SSP-IDs       
    %         
    %         % Run 4-Star Matching Alogrithm on 4 Stars
    %         [st_n_match, st_result] = st_4SM(st_4SM_input, st_RF_SC, st_4SM_constants);
    %         
    %         if st_n_match == 0
    %             % If no stars were matched, proceed with next iteration
    %             continue; 
    %         else
    %             
    %             st_flag_ID_err = st_check_ID_err(st_result, st_ref_ID, st_N);
    %             
    %             if st_flag_ID_err == 1
    %                 continue
    %             else
    %                 % Update Match Matrices
    %                 [st_Match, st_UnMatch, st_N_Match, st_N_UnMatch] = ...
    %                 st_update_match_matrix(st_result, st_Match, st_UnMatch, st_N_Match, st_N_UnMatch);
    %             end 
    %         end
    %%%%%%%%%%%%% END!
        end
    end

    %% Verification Step
    %disp('number: '+sm_counter.N_Matched);
    %%Trim Match Matrix to remove redundant zero rows
    sm_Matched = sm_Matched(1:sm_counter.N_Matched, :);
    [sm_counter.N_Verified, sm_Verified, sm_counter.N_Failed, sm_Failed] = ...
        sm_verify_4SM(sm_Matched, sm_counter.N_Matched, SM_const, sm_PP_LIS_output);


    %% Generate Output
    
    % Save as output as structrue
    sm_output.bi = sm_bi;
    sm_output.Matched = sm_Matched;
    sm_output.NotMatched = sm_NotMatched;
    sm_output.counters = sm_counter;
    sm_output.Verified = sm_Verified; %
    sm_output.Failed = sm_Failed; %
    %sm_output.Verified = sm_Matched;
    %sm_output.Failed = 0;
    
    sm_output.N = sm_counter.N_Verified;
    sm_output.op_bi = sm_PP_LIS_output.CONST_4SM.sm_GD_SC(sm_Verified.SSP_ID(:),:);
    sm_output.op_ri = sm_Verified(:, {'FE_ID', 'X', 'Y', 'Z'});
    %sm_output.N = sm_counter.N_Matched;
    %sm_Matched.SSP_ID(:) = [1745;4655;70;6136;6542;1129;1500;2436;31;4530;2377;7059];
    %sm_output.op_bi = sm_PP_LIS_output.CONST_4SM.sm_GD_SC(sm_Matched.SSP_ID(:),:);
    %sm_output.op_ri = sm_Matched(:, {'FE_ID', 'X', 'Y', 'Z'});
    
    sm_output.status = 'Done';
    sm_output.TM_input = [fe_output.centroids.X(sm_Verified.FE_ID) fe_output.centroids.Y(sm_Verified.FE_ID) sm_Verified.SSP_ID];
end