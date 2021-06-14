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
startidx_nextpred = 1;

disp(sorted_predmat); % delete
disp(sorted_truemat); % delete
% Code for sorting before matching

    for i_rw = 1:size(sorted_predmat,1)
        n_less_r_TM = 0; % number of instances when dist_x_TM < sm_TM_RBM_R
        n_more_r_TM = 0; % number of instances when dist_x_TM > sm_TM_RBM_R and diff_x_TM < 0
        n_truemat_TM = 0; % denotes the total number of true centroids checked for every predicted centroid
        startidx_TM = startidx_nextpred;
        for j_rw = startidx_TM:size(sorted_truemat,1)
            diff_x_TM = sorted_truemat(j_rw,1) - sorted_predmat(i_rw,1);
            diff_y_TM = sorted_truemat(j_rw,2) - sorted_predmat(i_rw,2);
            dist_x_TM = abs(diff_x_TM);
            dist_y_TM = abs(diff_y_TM);     
            n_truemat_TM = n_truemat_TM + 1;
            if dist_x_TM < sm_TM_RBM_R
                if n_less_r_TM==0 % checks if it is the first instance that dx < r
                    startidx_nextpred = j_rw;  % denotes the starting point for the next predicted centroid
                end
                n_less_r_TM = n_less_r_TM + 1; 
                if dist_y_TM < sm_TM_RBM_R
                    if isempty(sm_TM_RBM_matchmat)==1
                        sm_TM_RBM_matchmat = [sm_TM_RBM_matchmat ; sorted_predmat(i_rw, :) sorted_truemat(j_rw,:)];
                    else
                        if (sum(ismember(sorted_predmat(i_rw, :), sm_TM_RBM_matchmat(:, 1:2)))~=2) && (sum(ismember(sorted_truemat(j_rw, :), sm_TM_RBM_matchmat(:, 3:4)))~=2)
                            sm_TM_RBM_matchmat = [sm_TM_RBM_matchmat ; sorted_predmat(i_rw, :) sorted_truemat(j_rw,:)];
                        else
                            if sum(ismember(sorted_predmat(i_rw, :), sm_TM_RBM_matchmat(:, 1:2))) == 2
                                disp('More than one match for a single predicted centroid, abort!');                                
                                % delete the entry of sorted_predmat (i_rw) from sm_TM_RBM_matchmat since its a faulty match :/
                                sm_TM_RBM_matchmat(ismember(sm_TM_RBM_matchmat(:,1:2), sorted_predmat(i_rw,:), 'rows'), :) = [];
                                
                            elseif sum(ismember(sorted_truemat(j_rw, :), sm_TM_RBM_matchmat(:, 3:4))) == 2
                                disp('More than one match for a single true centroid, abort!');
                                % delete the entry of sorted_truemat (j_rw) from sm_TM_RBM_matchmat since its a faulty match :/
                                sm_TM_RBM_matchmat(ismember(sm_TM_RBM_matchmat(:,3:4), sorted_truemat(j_rw,:), 'rows'), :) = [];
                            end
                            disp([i_rw, j_rw]); % delete
                            break;
                        end
                    end
                 end
            elseif dist_x_TM > sm_TM_RBM_R
                if diff_x_TM > 0
                    if n_less_r_TM==0 % denotes no occurence of dist_x_TM < sm_TM_RBM_R
                        startidx_nextpred = j_rw;  % denotes the starting point for the next predicted centroid
                    end
                    disp('End loop. No further checking required');
                    disp([i_rw, j_rw]); % delete
                    break;
                else 
                    n_more_r_TM = n_more_r_TM + 1;
                end
            end           
        end
        if n_more_r_TM == n_truemat_TM
            disp('Terminate Algorithm. All true centroids behind the predicted centroid. No further matching possible');
            disp([i_rw, j_rw]); % delete
            break;
        end
    end
    disp(sm_TM_RBM_matchmat); % delete
end
