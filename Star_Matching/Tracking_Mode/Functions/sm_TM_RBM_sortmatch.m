function [sm_TM_RBM_matchmat] = sm_TM_RBM_sortmatch (sorted_predmat, sorted_truemat, sm_TM_RBM_R)
%% Implements the Sorting before Matching optimisation technique for Radius Based Matching algorithm
% Parameters
%---------------
% sorted_predmat : (N,2) - Matrix
%   The sorted matrix of predicted centroids
% sorted_truemat : (M,2) - Matrix
%   The sorted matrix of true centroids obtained from full frame centroiding at the current time instant
% sm_TM_RBM_R : double
%   The radius value to be used for carrying out Radius based matching between predicted and true centroids
%
% Returns:
%--------------------
% sm_TM_RBM_matchmat : (L,4) - Matrix
%     The matrix of matched true and predicted centroids

%% Code
% Initialise st_TM_RBM_matchmat
sm_TM_RBM_matchmat = [];
% Index for keeping track of start indices for predicted centroids
startidx_TM = 1;

% Code for sorting before matching

    for i_rw = 1:size(sorted_predmat,1)
        n_less_r_TM = 0; % number of instances when dist_x_TM < sm_TM_RBM_R
        n_more_r_TM = 0; % number of instances when dist_x_TM > sm_TM_RBM_R and diff_x_TM < 0
        n_truemat_TM = 0; % denotes the total number of true centroids checked for every predicted centroid
        for j_rw = startidx_TM:size(sorted_truemat,1)
            diff_x_TM = sorted_truemat(j_rw,1) - sorted_predmat(i_rw,1);
            diff_y_TM = sorted_truemat(j_rw,2) - sorted_predmat(i_rw,2);
            dist_x_TM = abs(diff_x_TM);
            dist_y_TM = abs(diff_y_TM);     
            n_truemat_TM = n_truemat_TM + 1;
            if dist_x_TM < sm_TM_RBM_R
                if n_less_r_TM==0 % checks if it is the first instance that dx < r
                    startidx_TM = j_rw;  % denotes the starting point for the next predicted centroid
                end
                n_less_r_TM = n_less_r_TM + 1; 
                if dist_y_TM < sm_TM_RBM_R
                    if isempty(sm_TM_RBM_matchmat)==1
                        sm_TM_RBM_matchmat = [sm_TM_RBM_matchmat ; sorted_predmat(i_rw, :) sorted_truemat(j_rw,:)];
                    else
                        if ismember(sorted_predmat(i_rw, :), sm_TM_RBM_matchmat(:, 1:2)) ~= [1,1]
                            sm_TM_RBM_matchmat = [sm_TM_RBM_matchmat ; sorted_predmat(i_rw, :) sorted_truemat(j_rw,:)];
                        else
                            disp('More than one match for a single predicted centroid, abort!');
                            break;
                        end
                    end
                 end
            elseif dist_x_TM > sm_TM_RBM_R
                if diff_x_TM > 0
                    if n_less_r_TM==0 % denotes no occurence of dist_x_TM < sm_TM_RBM_R
                        startidx_TM = j_rw;  % denotes the starting point for the next predicted centroid
                    end
                    disp('End loop. No further checking required');
                    break;
                else 
                    n_more_r_TM = n_more_r_TM + 1;
                end
            end           
        end
        if n_more_r_TM == n_truemat_TM
            disp('Terminate Algorithm. All true centroids behind the predicted centroid. No further matching possible');
            break;
        end
    end
end
