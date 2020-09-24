function sm_SIM = sm_gnrt_SIM(sm_c_img_AngDst, SM_const, sm_PP_LIS_output)
    % Generates the Star Identification Matrix (SIM) from a given array of
    % angular distances between those of four stars, using the Reference
    % Star Catalogue and the Guide Star Catalogue
    % Parameters:
    % -----------
    % st_c_img_AngDst: --------
    % st_RF_SC: -----------
    % st_consts_4SM:
    % Returns:
    % --------
    % st_SIM: ( (st_n_GC, 6) - Matrix )
    %   The Star Identification Matrix (SIM). The $i^{th}$ row of the 
    %   matrix corresponds to the $i^{th}$ SSP-ID star. There are thus as 
    %   many rows in SIM as there are in the Guide Star Catalogue = 
    %   (st_n_GC). The $j^{th}$ column corresponds to a boolean value. If 
    %   an element $SIM_{ij}$ is 1 $\implies$ $S_j^{th}$ input star matched 
    %   to the $i^{th}$ star of the Guide Star Catalogue
    
    %% Generate Star Identification Matrix
    sm_SIM = zeros(sm_PP_LIS_output.CONST_4SM.sm_n_GC, 6); % Initialize Star Identification Matrix

    for j_idx = 1:6
        %% Update (j-th) column of SIM for stars found in CSPA
        
        sm_AngDst = sm_c_img_AngDst.cos_theta(j_idx); % Angular distance of (j-th) pair
             
        % Determine candidate star pair array
        [sm_CSPA, ~] = sm_gnrt_CSPA(sm_AngDst, SM_const, sm_PP_LIS_output);
        
        if isempty(sm_CSPA) == 0        
            for i_idx = 1:length(sm_CSPA)
                SSP_ID = sm_CSPA(i_idx); % Possible SSP_ID

                %% Update Matched Element        

                % Increment  value
                %SIM(SSP_ID, j_idx) = SIM(SSP_ID, j_idx) + 1; 

                % Update value
                sm_SIM(SSP_ID, j_idx) = 1; 
            end
        end
    end
end