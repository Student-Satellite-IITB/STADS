function [SMM, mtch_rows] = st_gnrt_SMM(st_SIM, n_rw_GC, c_fe_IDs) 
    % Evaluates the Star Identification Matrix to identify the stars that 
    % have been matched through the 4-Star Matching Algorithm to generate 
    % the Star Matched Matrix (SMM)
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
    % n_rw_GC: (Integer)
    %   The size (number of rows) of the Guide Catalogue
    % c_fe_IDs: ( (4,1) - Matrix )
    %   Has the Feature Extraction IDs of stars that are used to generate 
    %   c_img_AngDst, in the following order: 
    %   $[S_1 ; S_2 ; S_3 ; S_4]$
    % Returns:
    % --------
    % SMM: ( (4,3) - Matrix )
    %   The Star Matched Matrix. The first column consists of the Feature
    %   Extraction IDs of the stars, the second column consists of matched
    %   SSP-ID (if there is no match: $0$ is updated), and the third column
    %   consists of the number of rows in SIM that matched the condition of 
    %   $S_i^{th}$ star
    % mtch_rows: ( (4, X) - Cell Array )
    %   $i^{th}$ element consists of a (X,1) - Matrix, that stores the 
    %   SSP-IDs of the rows that match the $i^{th}$ condition

    %% Code
    
    %% Initialize Variables
    SMM = zeros(4,3); % Initialize SMM
    SMM(:, 1) = c_fe_IDs; % Append Feature Extraction IDs
    
    Check_Conditions = [1, 1, 1 ,0, 0, 0;
                 1, 0, 0, 1, 1, 0;
                 0, 1, 0, 1, 0, 1;
                 0, 0, 1, 0, 1, 1]; % Check conditions

    % Stores the indices of the rows that match the (i-th) condition
    mtch_idx = boolean(zeros(n_rw_GC, 1)); 
    
    mtch_rows = {0; 0; 0; 0}; % Initialize variable

    for i_idx = 1:4
             Cond_i = Check_Conditions(i_idx, :); % Store the (i-th) row

             for j_idx = 1:n_rw_GC
                 rw = st_SIM(j_idx, :); % Extract (j-th) row of SIM

                 if rw == Cond_i
                     mtch_idx(j_idx) = true; % Update boolean value
                 else
                     mtch_idx(j_idx) = false; % Update boolean value
                 end
             end
             
             % Find the indices of all non-zero elements
             mtch_rows_i = find(mtch_idx); 
             mtch_rows{i_idx} = mtch_rows_i; % Append matched indices
             
             % Number of rows that match (i-th) condition
             N = length(mtch_rows_i); 
             SMM(i_idx, 3) = N; % Append number of matched rows
             
             if N == 1
                 % Append the index of the matched row
                 SMM(i_idx, 2) = mtch_rows_i; 
             else
                 SMM(i_idx, 2) = 0;
             end
    end
end