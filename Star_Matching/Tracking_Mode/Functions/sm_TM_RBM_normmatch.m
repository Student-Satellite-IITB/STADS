function sm_TM_RBM_matchmat = sm_TM_RBM_normmatch (sorted_predmat, sorted_truemat, sm_TM_RBM_R)
%% Implements brute-force Radius Based Matching to match the predicted and true centroids without any optimisations
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
% sm_TM_RBM_matchmat = zeros(max(size(sorted_predmat,1),size(sorted_truemat,1)),4);
    for i_rw = size(sorted_predmat, 1)
        for j_rw = size(sorted_truemat, 1)
            % Calculate the euclidean distance between the predicted and the true centroid
            euclid_dist = sqrt((sorted_predmat(i_rw, 1)-sorted_truemat(j_rw,1))^2 + (sorted_predmat(i_rw, 2)-sorted_truemat(j_rw,2))^2);
            if euclid_dist < sm_TM_RBM_R
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
        end
    end
end
