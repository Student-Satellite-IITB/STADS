function SIM = st_gnrt_SIM (c_img_AngDst, st_RF_SC, n_rw_GC, st_M, st_Q, st_DELTA)
    % Generates the Star Identification Matrix (SIM) from a given array of
    % angular distances between those of four stars, using the Reference
    % Star Catalogue and the Guide Star Catalogue
    % Parameters:
    % -----------
    % c_img_AngDst: ( (6,1) - Matrix )
    %   Has the angular distances ( in cos(theta) ) between those of four
    %   stars in the following order:
    %   (S1, S2) ; (S1, S3) ; (S1, S4); (S2, S3); (S2, S4); (S3, S4);
    %   <<< NOTE: THE ABOVE ORDER IS IMPORTANT, AND SHOULD BE FOLLOWED! >>>
    % st_RF_SC: ( (N, 3) - Matrix )
    %   The Reference catalogue, which has the following columns:
    %   SSP_ID_1 , SSP_ID_2 , K_Vec
    % n_rw_GC: (Integer)
    %   The number of stars (= number of rows) in the Guide Star Catalogue
    % st_M: (Float)
    %   The slope of the Z-vector line
    % st_Q: (Float)
    %   The y-intercept of the Z-vector line
    % st_DELTA: (Float)
    %   The $\delta$ constant that determines the tolerance of the size 
    %   window when searching for an angular distance value in the 
    %   Reference Star Catalogue
    % Returns:
    % --------
    % SIM: ( (n_rw_GC, 6) - Matrix )
    %   The Star Identification Matrix (SIM). The $i^{th}$ row of the 
    %   matrix corresponds to the $i^{th}$ SSP-ID star. There are thus as 
    %   many rows in SIM as there are in the Guide Star Catalogue = 
    %   (n_rw_GC). The $j^{th}$ column corresponds to a boolean value. If 
    %   an element $SIM_{ij}$ is 1 $\implies$ $S_j^{th}$ input star matched 
    %   to the $i^{th}$ star of the Guide Star Catalogue

    %% Generate Star Identification Matrix
    SIM = zeros(n_rw_GC, 6); % Initialize Star Identification Matrix

    for j_idx = 1:6
        %% Update (j-th) column of SIM for stars found in CSPA
        
        str_AngDst = c_img_AngDst(j_idx); % Angular distance of (j-th) pair
             
        % Determine candidate star pair array
        [CSPA, ~] = st_gnrt_CSPA(str_AngDst, st_DELTA, st_M, st_Q, st_RF_SC);
        
        for i_idx = 1:length(CSPA)
            SSP_ID = CSPA(i_idx); % Possible SSP_ID

            %% Update Matched Element        
            
            % Increment  value
            %SIM(SSP_ID, j_idx) = SIM(SSP_ID, j_idx) + 1; 
            
            % Updating value
            SIM(SSP_ID, j_idx) = 1; 
        end
    end
end