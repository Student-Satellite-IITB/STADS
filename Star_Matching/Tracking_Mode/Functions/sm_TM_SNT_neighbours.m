function [sm_TM_SNT_vec] = sm_TM_SNT_neighbours (sm_star_ID, sm_consts_TM, is_degree )
    %% Finds the Star Neighbours around st_star_id within a radius of st_TM_SNT_R
    % Parameters:
    % ---------------
    % sm_star_ID : int
    %    Star ID around which neighbours have to be found. 
    % sm_PP_SC : (N, 4) - Matrix 
    %    The preprocessed star catalogue. 
    % sm_TM_SNT_R : double
    %   The radius around each star in which star neighbours will be searched. 

    % Return:
    % ----------------
    % sm_TM_SNT_vec : (1, N) - Matrix
    %     The star neighbours of sm_star_ID

    %% Finding the star id in the preprocessed star catalogue
    tmp_neighbours_1 = sm_consts_TM.sm_PP_SC(find(sm_consts_TM.sm_PP_SC(:,1) == sm_star_ID),:); % Star IDs in the 1st column of st_PP_SC
    tmp_neighbours_2 = sm_consts_TM.sm_PP_SC(find(sm_consts_TM.sm_PP_SC(:,2) == sm_star_ID),:); % Star IDs in the 2nd column of st_PP_SC

    %% Initialise st_TM_SNT_star_ID with st_star_ID
    sm_TM_SNT_vec = [sm_star_ID];

    %% Add star neighbours to st_TM_SNT_star_ID 
    if is_degree == true 
        for tmp_idx = 1:size(tmp_neighbours_1, 1)
            if tmp_neighbours_1(tmp_idx, 4) <= sm_consts_TM.sm_TM_SNT_R % Check if angular distance is less than st_TM_SNT_R
                sm_TM_SNT_vec = [sm_TM_SNT_vec , tmp_neighbours_1(tmp_idx, 2)];
            end
        end
        for tmp_idx = 1:size(tmp_neighbours_2, 1)
            if tmp_neighbours_2(tmp_idx,4) <= sm_consts_TM.sm_TM_SNT_R % Check if angular distance is less than st_TM_SNT_R
                sm_TM_SNT_vec = [sm_TM_SNT_vec , tmp_neighbours_2(tmp_idx, 1)];
            end
        end

    elseif is_degree == false
        for tmp_idx = 1:size(tmp_neighbours_1, 1)
            if tmp_neighbours_1(tmp_idx,3) > sm_consts_TM.sm_TM_SNT_R  % Check if cosine of angular distance is greater than st_TM_SNT_R
               sm_TM_SNT_vec = [sm_TM_SNT_vec , tmp_neighbours_1(tmp_idx, 2)];
            end
        end
        for tmp_idx = 1 : size(tmp_neighbours_2, 1)
            if tmp_neighbours_2 (tmp_idx, 3) > sm_consts_TM.sm_TM_SNT_R % Check if cosine of angular distance is greater than st_TM_SNT_R
               sm_TM_SNT_vec = [sm_TM_SNT_vec , tmp_neighbours_2(tmp_idx, 1)];
            end
        end
    end

end


