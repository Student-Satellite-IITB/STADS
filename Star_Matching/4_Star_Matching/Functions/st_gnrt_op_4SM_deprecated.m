function [st_op_bi, st_op_ri, n_st_strs] = st_gnrt_op_4SM_deprecated(st_SMM, st_bi, st_GD_SC)
    % Evaluates the Star Matched Matrix, to generate the output in the 
    % format required by Estimation - Body-frame vectors, and 
    % Inertial-frame vectors of the matched stars
    % Parameters:
    % -----------
    % st_SMM: ( (4,3) - Matrix )
    %   The Star Matched Matrix. The first column consists of the Feature
    %   Extraction IDs of the stars, the second column consists of matched
    %   SSP-ID (if there is no match: $0$ is updated), and the third column
    %   consists of the number of rows in SIM that matched the condition of 
    %   $S_i^{th}$ star
    % st_bi: ( (N, 4) - Matrix )
    %   The body-frame vector of each corresponding star. It is a
    %   unit-vector represented in $(X, Y, Z)$ format, with the origin at 
    %   the center of the sensor and positive z-axis pointing out of the 
    %   lens. The first column represents the index of the corresponding 
    %   star as denoted in fe_output
    % st_GD_SC: ( (n_rw_GC, 4) - Matrix )
    %   The Guide catalogue, which has the following columns:
    %   SSP_ID , X , Y , Z
    % Returns:
    % --------
    % st_op_bi: ( (N, 3) - Matrix )
    %   The body-frame vectors - $(X,Y,Z)$, of the matched stars
    % st_op_ri: ( (N, 3) - Matrix )
    %   The inertial-frame vectors - $(X,Y,Z)$, of the corresponding matched
    %   stars
    %   <<< NOTE: (N) in both cases should be equal! The (i-th) body-frame
    %   and the (i-th) inertial-frame vector should correspond to the same
    %   star >>
    % n_st_strs : (Integer)
    %   The number of stars matched by Star Matching
    %% Code

    idx = find( st_SMM(:, 2) ); % Indices of all matched stars

    if isempty(idx) == 1
        st_op_bi = 0;
        st_op_ri = 0;
        n_st_strs = 0;
    else
        SSP_IDs = st_SMM(idx, 2); % Extract SSP IDs of matched stars
        
        % Extract Feature Extraction IDs of matched stars
        fe_IDs = st_SMM(idx, 1); 

        % Extract Body-frame vectors of matched stars
        st_op_bi = st_bi(fe_IDs, 2:4); 

        % Extract Inertial-frame vectors of matched stars
        st_op_ri = st_GD_SC(SSP_IDs, 2:4); 
        
        % Number of matched stars
        sz = size(st_op_bi);
        n_st_strs = sz(1);        
    end
end