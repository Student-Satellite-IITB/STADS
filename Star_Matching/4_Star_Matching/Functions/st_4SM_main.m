function [st_output, es_input] = st_4SM_main(fe_output, fe_n_str, ...
    st_consts_4SM, st_consts_opt, st_catalogues)
    
    %% Code

    % Generate body-frame vectors of stars 
    st_bi = st_gnrt_bi(fe_output, fe_n_str, st_consts_opt.Focal_Length); 

    %% 4-Star Matching Alogorithm

    % Initialze Match Matrices
    st_Match = zeros(fe_n_str, 5);
    st_UnMatch = st_bi;

    % Intialize counter variables
    st_N_Match = 0; % Number of matched stars
    st_N_UnMatch = fe_n_str; % Number of unmatched stars

    %%
    st_flag_circshift = 0;
    for st_iter_total = 1:st_consts_4SM.st_ITER_MAX_4SM % Total number of iterations allowed for Star-Matching

        if (st_N_UnMatch >= 4) && (st_N_Match < st_consts_4SM.es_N_EST)
            % Extract first four stars from UnMatch matrix
            st_4SM_input = st_UnMatch(1:4, :); 

            % Run 4-Star Matching Alogrithm on 4 Stars
            [st_n_match, st_result] = st_4SM(st_4SM_input, st_consts_4SM, st_catalogues);

            if st_n_match == 0 
                % If no stars were matched, shift the rows of Non_Match matrix
                % downward by one unit
                st_UnMatch = circshift( st_UnMatch, [1, 0] ); 

                st_flag_circshift = st_flag_circshift + 1; % Update flag

                if st_flag_circshift == fe_n_str 
                    % If circshift has been performed fe_n_str times, it is
                    % periodic. Thus break the Star-Matching iteration to
                    % prevent redundant periodic computation
                    % disp('Error: flag_circshift!');
                    break;
                end

            else
                % Update Match Matrices
                [st_Match, st_UnMatch, st_N_Match, st_N_UnMatch] = ...
                st_update_match_matrix(st_result, st_Match, st_UnMatch, st_N_Match, st_N_UnMatch);
            end

        elseif (st_N_Match >= st_consts_4SM.es_N_EST) || (st_N_UnMatch == 0)
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
    % Trim Match Matrix to remove redundant zero rows
    st_Match = st_Match(1:st_N_Match, :);

    [st_N_Verify, st_Verify, st_N_Fail, st_Fail] = ...
        st_verify_4SM(st_Match, st_N_Match, st_catalogues.st_GD_SC, st_consts_4SM.st_verify_tol);


    %% Generate Output

    % Generate output in the format required by Estimation
    [st_op_bi, st_op_ri] = st_gnrt_op_4SM_v2(st_Verify(:, 1:5), st_catalogues.st_GD_SC);
    
    % Save as output as structrues
    st_output.st_iter_total = st_iter_total;
    st_output.st_Match = st_Match;
    st_output.st_N_Match = st_N_Match;
    st_output.st_UnMatch = st_UnMatch;
    st_output.st_N_UnMatch = st_N_UnMatch;
    st_output.st_op_bi =  st_op_bi;
    st_output.st_op_ri = st_op_ri;
    st_output.st_N_Fail = st_N_Fail;
    st_output.st_Fail = st_Fail;
    st_output.st_N_Verify = st_N_Verify;
    st_output.st_Verify = st_Verify;
    
    es_input.st_N = st_N_Verify;
    es_input.st_op_bi =  st_op_bi;
    es_input.st_op_ri = st_op_ri;
end