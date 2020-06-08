function SIM = st_gnrt_SIM (st_c_img_AngDst, st_RF_SC, st_4SM_constants)
    % Generates the Star Identification Matrix (SIM) from a given array of
    % angular distances between those of four stars, using the Reference
    % Star Catalogue and the Guide Star Catalogue
    % Parameters:
    % -----------
    % st_c_img_AngDst: ( (6,1) - Matrix )
    %   Has the angular distances ( in cos(theta) ) between those of four
    %   stars in the following order:
    %   $(S_1, S_2) ; (S_1, S_3) ; (S_1, S_4) ; (S_2, S_3) ; (S_2, S_4) ; 
    %   (S_3, S_4)$
    %   <<< NOTE: THE ABOVE ORDER IS IMPORTANT, AND SHOULD BE FOLLOWED! >>>
    % st_RF_SC: ( (st_n_RC, 3) - Matrix )
    %   The Reference catalogue, which has the following columns:
    %   SSP_ID_1 , SSP_ID_2 , K_Vec
    % st_4SM_constants: ( (4, 1) - Matrix )
    %   An array that constains the following constants:
    %   [st_n_GC, st_M, st_Q, st_DELTA]
    % Returns:
    % --------
    % SIM: ( (st_n_GC, 6) - Matrix )
    %   The Star Identification Matrix (SIM). The $i^{th}$ row of the 
    %   matrix corresponds to the $i^{th}$ SSP-ID star. There are thus as 
    %   many rows in SIM as there are in the Guide Star Catalogue = 
    %   (st_n_GC). The $j^{th}$ column corresponds to a boolean value. If 
    %   an element $SIM_{ij}$ is 1 $\implies$ $S_j^{th}$ input star matched 
    %   to the $i^{th}$ star of the Guide Star Catalogue
    
    %% Upack constants
    st_n_GC = st_4SM_constants(1);
    st_M = st_4SM_constants(2);
    st_Q = st_4SM_constants(3);
    st_DELTA = st_4SM_constants(4); 
    
    %% Generate Star Identification Matrix
    SIM = zeros(st_n_GC, 6); % Initialize Star Identification Matrix

    for j_idx = 1:6
        %% Update (j-th) column of SIM for stars found in CSPA
        
        st_AngDst = st_c_img_AngDst(j_idx); % Angular distance of (j-th) pair
             
        % Determine candidate star pair array
        [st_CSPA, ~] = st_gnrt_CSPA(st_AngDst, st_DELTA, st_M, st_Q, st_RF_SC);
        
        for i_idx = 1:length(st_CSPA)
            SSP_ID = st_CSPA(i_idx); % Possible SSP_ID

            %% Update Matched Element        
            
            % Increment  value
            %SIM(SSP_ID, j_idx) = SIM(SSP_ID, j_idx) + 1; 
            
            % Updating value
            SIM(SSP_ID, j_idx) = 1; 
        end
    end
end