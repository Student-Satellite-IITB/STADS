    function [sm_SMM, sm_MatchedRows] = sm_gnrt_SMM(sm_SIM, sm_c_fe_ID, sm_PP_LIS_output) 
    % Evaluates the Star Identification Matrix to identify the stars that 
    % have been matched through the 4-Star Matching Algorithm to generate 
    % the Star Matched Matrix (SMM).
    % Of the four stars that are provided as input to the 4-Star Matching 
    % Algorithm, the $S_i$ star is said to have been matched, if only one 
    % such row of the Star Identification Matrix as given below is present:
    %   $S_1 - [1, 1, 1 ,0, 0, 0]$
    %   $S_2 - [1, 0, 0, 1, 1, 0]$
    %   $S_3 - [0, 1, 0, 1, 0, 1]$
    %   $S_4 - [0, 0, 1, 0, 1, 1]$
    % This pattern arises out of the fact that angular distances that are 
    % provided as input follow the order:
    % $(S_1, S_2) ; (S_1, S_3) ; (S_1, S_4) ; (S_2, S_3) ; (S_2, S_4) ; 
    % (S_3, S_4)$
    % Reference:
    % ----------
    % Refer 2. '4-Star Matching Strategy' - Dong, Ying & Xing, Fei & You, 
    % Zheng. (2006). Brightness Independent 4_Star Matching Algorithm for 
    % Lost-in-Space 3-Axis Attitude Acquisition. Tsinghua Science & 
    % Technology. 11. 543-548. 10.1016/S1007-0214(06)70232-2. 
    % Prameters:
    % ----------
    % st_SIM: ( (n_rw_GC, 6) - Matrix )
    %   The Star Identification Matrix    
    % st_n_GC: (Integer)
    %   The number of stars (= number of rows) in the Guide Star Catalogue
    % st_c_fe_ID: ( (4,1) - Matrix )
    %   Has the Feature Extraction IDs of stars that are used to generate 
    %   c_img_AngDst, in the following order: 
    %   $[S_1 ; S_2 ; S_3 ; S_4]$
    % Returns:
    % --------
    % st_SMM: ( (4,3) - Matrix )
    %   The Star Matched Matrix. The first column consists of the Feature
    %   Extraction IDs of the stars, the second column consists of matched
    %   SSP-ID (if there is no match: $0$ is updated), and the third column
    %   consists of the number of rows in SIM that matched the condition of 
    %   $S_i$ star
    % st_mtch_rows: ( (4, 2) - Cell Array )
    %   The columns of the cell array are as follows:
    %   $1^{st}$ column - Feature Extraction ID
    %   $2^{nd}$ column - $i^{th}$ element consists of a (X,1) - Matrix, 
    %   that stores the SSP-IDs that matched the $i^{th}$ condition
    
    %% Code
    
    %% Initialize Variables
    sm_SMM = array2table( ...
        zeros(4, 3), 'VariableNames', ...
        {'FE_ID', 'SSP_ID', 'Num_MatchedRows'} ...
    ); % Initialize SMM 
    sm_SMM(:, 1) = sm_c_fe_ID; % Append Feature Extraction IDs
    
    sm_Check_Conditions = [1, 1, 1 ,0, 0, 0;...
                         1, 0, 0, 1, 1, 0;...
                         0, 1, 0, 1, 0, 1;...
                         0, 0, 1, 0, 1, 1]; % Check conditions

    % Stores the indices of the rows that match the (i-th) condition
    sm_match_idx = zeros(sm_PP_LIS_output.CONST_4SM.sm_n_GC, 1); 
    
    sm_MatchedRows = {0; 0; 0; 0}; % Initialize variable
    %% Iterate
    for i_idx = 1:4
             cond_i = sm_Check_Conditions(i_idx, :); % Store the (i-th) row

             for j_idx = 1:sm_PP_LIS_output.CONST_4SM.sm_n_GC
                 rw = sm_SIM(j_idx, :); % Extract (j-th) row of SIM

                 if isequal(rw, cond_i)
                     sm_match_idx(j_idx) = 1; % Update boolean value
                 else
                     sm_match_idx(j_idx) = 0; % Update boolean value
                 end
             end
             
             % Find the indices of all non-zero elements
             mtch_rows_i = find(sm_match_idx); 
             sm_MatchedRows{i_idx, 1} = sm_SMM.FE_ID(i_idx); % Append Feature Extraction ID
             sm_MatchedRows{i_idx, 2} = mtch_rows_i; % Append matched indices
             
             % Number of rows that match (i-th) condition
             N = length(mtch_rows_i); 
             sm_SMM.Num_MatchedRows(i_idx) = N; % Append number of matched rows
             
             if N == 1
                 % Append the index of the matched row
                 sm_SMM.SSP_ID(i_idx) = mtch_rows_i; 
             else
                 sm_SMM.SSP_ID(i_idx) = 0;
             end
    end
end