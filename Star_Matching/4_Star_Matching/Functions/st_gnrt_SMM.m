    function [st_SMM, st_mtch_rows] = st_gnrt_SMM(st_SIM, n_rw_GC, st_c_fe_ID) 
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
    % n_rw_GC: (Integer)
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
    st_SMM = zeros(4,3); % Initialize SMM
    st_SMM(:, 1) = st_c_fe_ID; % Append Feature Extraction IDs
    
    st_Check_Conditions = [1, 1, 1 ,0, 0, 0;...
                         1, 0, 0, 1, 1, 0;...
                         0, 1, 0, 1, 0, 1;...
                         0, 0, 1, 0, 1, 1]; % Check conditions

    % Stores the indices of the rows that match the (i-th) condition
    mtch_idx = boolean(zeros(n_rw_GC, 1)); 
    
    st_mtch_rows = {0; 0; 0; 0}; % Initialize variable

    for i_idx = 1:4
             Cond_i = st_Check_Conditions(i_idx, :); % Store the (i-th) row

             for j_idx = 1:n_rw_GC
                 rw = st_SIM(j_idx, :); % Extract (j-th) row of SIM

                 if rw == Cond_i
                     mtch_idx(j_idx) = 1; % Update boolean value
                 else
                     mtch_idx(j_idx) = 0; % Update boolean value
                 end
             end
             
             % Find the indices of all non-zero elements
             mtch_rows_i = find(mtch_idx); 
             st_mtch_rows{i_idx, 1} = st_SMM(i_idx, 1); % Append Feature Extraction ID
             st_mtch_rows{i_idx, 2} = mtch_rows_i; % Append matched indices
             
             % Number of rows that match (i-th) condition
             N = length(mtch_rows_i); 
             st_SMM(i_idx, 3) = N; % Append number of matched rows
             
             if N == 1
                 % Append the index of the matched row
                 st_SMM(i_idx, 2) = mtch_rows_i; 
             else
                 st_SMM(i_idx, 2) = 0;
             end
    end
end