function sm_TM_SNT_output = sm_TM_SNT_match(sm_TM_RBM_matchmat, fe_output, sm_TM_SNT, sm_GD_SC, sm_TM_CP_F, sm_TM_Nth)
% function to identify the unmatched centroids using the matched stars and the Star Neighbourhood table

% first find which centroids in fe_output have been identified and then find their corresponding star ids from matchmat
% then pick one star id, find neighbours from SNT, eliminate them from the set of neighbours, then find the angular distance of the picked star id with the remaining neighbours
% now find the angular distance between the picked star id and the remaining unmatched centroids from fe_output
% the closest value is taken and the unmatched centroid is assigned with that star id
% keep repeating the process till u reach a angular distance which is greater than any of the neighbours of SNT in which case u need to move to the next matched star and repeat the process
% the above condition may happen if an unmatched centroid is too far away to be included in the neighbours of the beginning matched star.

sm_TM_SNT_output = []; % contains only the newly identified star ids

num_matched_ids = size(sm_TM_RBM_matchmat,1); % number of star ids that have been matched in the entire iteration 

unmatched_centroids = setdiff (fe_output, sm_TM_RBM_matchmat(:,3:4), 'rows');

picked_id = sm_TM_RBM_matchmat(1,5); % picking the 1st identified star id for matching the unmatched centroids

neighbours = sm_TM_SNT(picked_id,:); % accessing the neighbours of the picked star id

unmatched_neighbours = setdiff (neighbours, sm_TM_RBM_matchmat(2:end,5)); % dropping the already identified ids from the set of neighbours

% sm_TM_calc_angdist: function to calculate angular distances between given two pairs of centroids OR two star ids
% is_id: a boolean variable to specify whether angular distance has to be calculated using centroids or star ids

known_angdist = []; % calculates the angular distances between the picked id and the neighbours all at ONCE.
for i = 1:size(unmatched_neighbours,2)
    is_id = true;
    known_angdist = [known_angdist; sm_TM_calc_angdist(picked_id, unmatched_neighbours(i), is_id, sm_GD_SC, sm_TM_CP_F)];
end
% the loop for matching the unmatched centroids starts
for i=1:size(unmatched_centroids,1)
    is_id = false;
    unknown_angdist = sm_TM_calc_angdist(unmatched_centroids(i,:), sm_TM_RBM_matchmat(ismember(sm_TM_RBM_matchmat(:,5),picked_id),3:4), is_id, sm_GD_SC, sm_TM_CP_F);
    for j = 1:size(known_angdist,1)
        if unknown_angdist > known_angdist(j) %% !!!IMPORTANT!!! - CONFIRM THIS ONCE WITH THE TEAM. ANOTHER OPTION CAN BE DEFINING A RANGE AROUND EACH NEIGHBOUR AND ONLY THEN CONSIDER IT MATCHED.
            % write code for appending the identfied starid
            sm_TM_SNT_output = [sm_TM_SNT_output; unmatched_neighbours(j)];
            num_matched_ids = num_matched_ids + 1; 
            break;
        end
    end
    if num_matched_ids >= sm_TM_Nth
        break; % N_th number of stars have been matched, no need to continue the SNT matching algorithm
    end
end
end