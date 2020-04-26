function [sm_op_bi, sm_op_ri] = sm_gnrt_op_4_str_mtch(sm_SMM, sm_bi, sm_GD_SC)
    % Evaluates Star Matched Matrix, to generate the output in the format
    % required by Estimation - Body-frame vectors, and Inertial-frame 
    % vectors of the matched stars
    % Parameters:
    % -----------
    % sm_SMM: (4,3) - Matrix
    %   The Star Matched Matrix. The first column consists of the Feature
    %   Extraction IDs of the stars, the second column consists of matched
    %   SSP ID (if there is no match: -1 is updated), and the third column
    %   consists of the number of rows in SIM that matched the condition of 
    %   (S_i - th) star
    % sm_bi: (N, 4) - Matrix
    %   The body-frame vector of each corresponding star. It is a
    %   unit-vector represented in (x,y,z) format, with the origin at the
    %   center of the sensor and positive z-axis pointing out of the lens.
    %   The first column corresponds to the index of the star as denoted in
    %   fe_output
    % sm_GD_SC: (N, 4) - Matrix
    %   The Guide catalogue, which has the following columns:
    %   SSP_ID , X , Y , Z
    % Returns:
    % --------
    % sm_op_bi: (N, 3) - Matrix
    %   The body-frame vectors - (X,Y,Z), of the matched stars
    % sm_op_ri: (N, 3) - Matrix
    %   The inertial-frame vectors - (X,Y,Z), of the corresponding matched
    %   stars
    % <<< NOTE: (N) in both cases should be equal! The (i-th) body-frame
    % and the (i-th) inertial-frame vector should correspond to the same
    % star >>
    %% Code

    idx = find( sm_SMM(:, 2) ); % Indices of all matched stars

    if isempty(idx) == 1
        sm_op_bi = 0;
        sm_op_ri = 0;
    else
        SSP_IDs = sm_SMM(idx, 2); % Extract SSP IDs of matched stars
        
        % Extract Feature Extraction IDs of matched stars
        fe_IDs = sm_SMM(idx, 1); 

        % Extract Body-frame vectors of matched stars
        sm_op_bi = sm_bi(fe_IDs, 2:4); 

        % Extract Inertial-frame vectors of matched stars
        sm_op_ri = sm_GD_SC(SSP_IDs, 2:4); 
    end
end