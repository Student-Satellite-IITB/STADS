% There will be another script which can call both LISA or TMA depending on the number of iterations already run and 
% the number of matched stars (greater than N_th for two consecutive iterations
function [sm_output] = sm_TM_main(fe_output, sm_output_curr, sm_output_prev, sm_consts_TM, sm_TM_SNT, ... 
    sm_catalogues, sort_dx, sort_before_match)
 
    % check if there are at least 2 common stars
    % n_comm = find(sm_output_curr(:,3)==sm_output_prev(:,3));
    [n_comm, i_curr, i_prev] = intersect(sm_output_curr(:,3),sm_output_prev(:,3));

    sm_output = [];

    % keep only the common entries (without star IDs)
    sm_TM_CP_prevmat = sm_output_prev (i_curr,:); 
    sm_TM_CP_currmat = sm_output_curr (i_prev,:); 

    if (length(n_comm) < 2)
        return; % terminates the TMA if less than 2 common stars
    else
        sm_TM_CP_predmat = sm_TM_CP_main (sm_TM_CP_prevmat(:,1:2), sm_TM_CP_currmat(:,1:2), sm_consts_TM.sm_TM_CP_F);
    end

    sm_TM_CP_predmat = [sm_TM_CP_predmat, sm_TM_CP_currmat(:,3)]; % appending star IDs with the predicted centroids

    % remove predicted centroids which lie outside the sensor FOV
    for i = 1 : size(sm_TM_CP_predmat,1)
        if (abs(sm_TM_CP_predmat(i,1)) > sm_consts_TM.sm_TM_FOV_x) || (abs(sm_TM_CP_predmat(i,2)) > sm_consts_TM.sm_TM_FOV_y)
            sm_TM_CP_predmat(i,:) = []; % removes the predicted centroid which lies outside the sensor FOV
        end
    end

    if (isempty(sm_TM_CP_predmat) == 1)
        return; % terminates TMA if no predicted centroids are within the sensor FOV
    end

    % implement radius based matching to match the predicted centroids with the true centroids
   % sort_dx = true; % if True : predicted and true centroids are sorted according to their x-coordinates
    %sort_before_match = true; % if True : Implement sorting before matching optimisation

    sm_TM_RBM_matchmat = sm_TM_RBM_main(sm_TM_CP_predmat(:,1:2), fe_output, sm_consts_TM.sm_TM_RBM_R, sort_dx ,sort_before_match);

    % append the star-ids of the matched predicted centroids
    % REDUNDANT CODE!!! THE REVISED IMPLEMENTATION IS DONE BELOW (L46 TO L48)
    % for i = 1:size(sm_TM_RBM_matchmat,1)
    %     star_id = sm_TM_CP_predmat(ismember(sm_TM_CP_predmat(:,1:2), sm_TM_RBM_matchmat(i,1:2),'rows'),3);
    %     sm_TM_RBM_matchmat = [sm_TM_RBM_matchmat star_id];
    % end
    [~,idx_star_id,~] = intersect(sm_TM_CP_predmat(:,1:2), sm_TM_RBM_matchmat(:,1:2),'rows');
    star_id = sm_TM_CP_predmat(idx_star_id,3);
    sm_TM_RBM_matchmat = [sm_TM_RBM_matchmat , star_id];

    % Now, if number of matched centroids is greater than equal to N_th,
    % then TMA is ended. Otherwise SNT is used to find more stars.

        if (size(sm_TM_RBM_matchmat,1) >= sm_consts_TM.sm_TM_Nth)
    %         for i=1:size(sm_TM_RBM_matchmat,1)
    %             sm_output = [sm_output; sm_catalogues.sm_GD_SC(sm_TM_RBM_matchmat(i,5),:)]; 
                  % outputs the star unit vector of the star ids from the Guide catalogue
    %         end
            sm_output = sm_catalogues.sm_GD_SC(sm_TM_RBM_matchmat(:,5),:);
            return;

        elseif (size(fe_output,1) > size(sm_TM_CP_predmat,1)) % checks if there are extra stars in the feature extraction output which were not included in the predicted centroids
            sm_TM_SNT_output = sm_TM_SNT_match (sm_TM_RBM_matchmat, fe_output, sm_TM_SNT, sm_catalogues.sm_GD_SC, ... 
                sm_consts_TM.sm_TM_CP_F, sm_consts_TM.sm_TM_Nth); % calls the SNT match function to identify the unmatched centroids using the matched stars    
    %         for i=1:size(sm_TM_RBM_matchmat,1)
    %             sm_output = [sm_output; sm_catalogues.sm_GD_SC(sm_TM_RBM_matchmat(i,5),:)]; % outputs the star unit vector of the star ids from the Guide catalogue
    %         end
            sm_output = sm_catalogues.sm_GD_SC(sm_TM_RBM_matchmat(:,5),:);
    %         for i=1:size(sm_TM_SNT_output,1)
    %             sm_output = [sm_output; sm_catalogues.sm_GD_SC(sm_TM_SNT_output(i),:)]; % outputs the star unit vector of the star ids from the Guide catalogue
    %         end
            sm_output = [sm_output, sm_catalogues.sm_GD_SC(sm_TM_SNT_output(:),:)];
        else
            return; % no new stars, terminate TMA and perform LISA in the current frame
        end
end
