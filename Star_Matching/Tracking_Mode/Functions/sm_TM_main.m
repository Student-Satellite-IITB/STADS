% There will be another script which can call both LISA or TMA depending on the number of iterations already run and 
% the number of matched stars (greater than N_th for two consecutive iterations
function [sm_output] = sm_TM_main(fe_output, sm_output_curr, sm_output_prev, sm_consts_TM)
 
% check if there are at least 2 common stars
[sm_TM_CP_prevmat, sm_TM_CP_currmat, is_two] = sm_TM_main_comm(sm_output_curr, sm_output_prev);

if (is_two == false)
    return; % terminates the TMA if less than 2 common stars
else
    sm_TM_CP_predmat = sm_TM_CP_main(sm_TM_CP_prevmat, sm_TM_CP_currmat, sm_consts_TM.sm_TM_CP_F);
end
    
% remove predicted centroids which lie outside the sensor FOV
for i=1:size(sm_TM_CP_predmat,1)
    if (abs(sm_TM_CP_predmat(i,1))>sm_consts_TM.sm_TM_FOV_l) || (abs(sm_TM_CP_predmat(i,2))>sm_consts_TM.sm_TM_FOV_b)
        sm_TM_CP_predmat(i,:)=[]; % removes the predicted centroid which lies outside the sensor FOV
    end
end

if (isempty(sm_TM_CP_predmat)==1)
    return; % terminates TMA if no predicted centroids are within the sensor FOV
end

% implement radius based matching to match the predicted centroids with the true centroids
is_dx = true; % if True : predicted and true centroids are sorted according to their x-coordinates
sort_before_match = true; % if True : Implement sorting before matching optimisation

sm_TM_RBM_matchmat = sm_TM_RBM_main(sm_TM_CP_predmat, fe_output, sm_consts_TM.sm_TM_RBM_R, is_dx, sort_before_match);

% Now, if number of matched centroids is greater than equal to N_th, then TMA is ended. Otherwise SNT is used to find more stars.

if (size(sm_TM_RBM_matchmat,1) > sm_consts_TM.sm_TM_Nth)
    sm_output = sm_TM_RBM_matchmat(:,5); % the fifth column contains the star IDs of the final matched centroids
    return;
else
    if (size(sm_TM_RBM_matchmat,1)>size(sm_TM_CP_predmat,1)) % checks if there are any new stars in the FOV which were not included in the predicted centroids
        sm_TM_SNT_output = sm_TM_SNT_match(sm_TM_RBM_matchmat, sm_TM_CP_predmat); % calls the SNT match function to identify the unmatched centroids using the matched stars
        
    else
        return; % no new stars, terminate TMA and perform LISA in the current frame
    end
end


