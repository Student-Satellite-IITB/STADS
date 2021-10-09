function [sm_TM_RBM_matchmat] = sm_TM_RBM_main (sm_TM_RBM_predmat, sm_TM_RBM_truemat, sm_TM_RBM_R, sort_dx, sort_before_match)
%% Matches the Predicted centroids with the True centroids
% Parameters
%---------------
% sm_TM_RBM_predmat : (N, 2) - Matrix
%   The matrix of predicted centroids
% sm_TM_RBM_truemat : (M,2) - Matrix
%   The matrix of true centroids obtained from full frame centroiding at the current time instant
% sm_TM_RBM_R : double
%   The radius value to be used for carrying out Radius based matching between predicted and true centroids
% sort_dx : Boolean
%   if True : predicted and true centroids are sorted according to their x-coordinates
% sort_before_match : Boolean
%   if True : Implement sorting before matching optimisation
%
% Returns:
%--------------------
% sm_TM_RBM_matchmat : (L,4) - Matrix
%     The matrix of matched true and predicted centroids

%% Code
    % sort the predicted and true centroids according to sort_dx
    [sorted_predmat, sorted_truemat] = sm_TM_RBM_sortmat (sm_TM_RBM_predmat, sm_TM_RBM_truemat, sort_dx);

    if sort_before_match == true
        % Radius based matching with sorted before matching
        sm_TM_RBM_matchmat = sm_TM_RBM_sortmatch (sorted_predmat, sorted_truemat, sm_TM_RBM_R);
    else 
        sm_TM_RBM_matchmat = sm_TM_RBM_normmatch (sorted_predmat, sorted_truemat, sm_TM_RBM_R);
    end
end
