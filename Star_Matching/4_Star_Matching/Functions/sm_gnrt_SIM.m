function SIM = sm_gnrt_SIM (c_img_AngDst, sm_RF_SC, n_rw_GC, sm_M, sm_Q, sm_DELTA)
    % Generates the Star Identification Matrix (SIM) from a given array of
    % angualar distances between those of four stars, using the Reference
    % Star Catalogue and the Guide Star Catalogue
    % Parameters:
    % -----------
    % c_img_AngDst: (6,1) - Matrix
    %   Has the angular distances ( in cos(theta) ) between those of four
    %   stars in the following order:
    %   (S1, S2) ; (S1, S3) ; (S1, S4); (S2, S3); (S2, S4); (S3, S4);
    %   <<< NOTE: THE ABOVE ORDER IS IMPORTANT, AND SHOULD BE FOLLOWED! >>>
    % sm_RF_SC: (N, 3) - Matrix
    %   The Reference catalogue, which has the following columns:
    %   SSP_ID_1 , SSP_ID_2 , K_Vec
    % n_rw_GC: Integer
    %   The size (number of rows) of the Guide Catalogue
    % sm_M: Float
    %   Slope of Z-Vector line
    % sm_Q: Float
    %   Coefficient of Z-Vector line 
    % sm_DELTA: Float
    %   The value of uncertainty constant to be used to find the range of
    %   angular distances from the Reference catalogue that match with
    %   the given ang_dist
    % Returns:
    % --------
    % SIM: (n_rw_GC, 6) - Matrix
    %   The Star Identification Matrix

    %% Generate Star Identification Matrix
    SIM = zeros(n_rw_GC, 6); % Initialize Star Identification Matrix

    for j_idx = 1:6
        %% Update (j-th) column of SIM for stars found in CSPA
        
        str_AngDst = c_img_AngDst(j_idx); % Angular distance of (j-th) pair
             
        % Determine candidate star pair array
        [CSPA, ~] = sm_gnrt_CSPA(str_AngDst, sm_DELTA, sm_Q, sm_M, sm_RF_SC);
        
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