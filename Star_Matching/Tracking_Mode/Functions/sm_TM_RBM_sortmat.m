function [sorted_predmat, sorted_truemat] = sm_TM_RBM_sortmat (sm_TM_RBM_predmat, sm_TM_RBM_truemat, sort_dx)
%% Function to sort the predicted and true centroids according to either x-coordinates or y-coordinates
% Parameters:
% -------------------
% sm_TM_RBM_predmat : (N, 2) - Matrix
%   The matrix of predicted centroids
% sm_TM_RBM_truemat : (M,2) - Matrix
%   The matrix of true centroids obtained from full frame centroiding at the current time instant
% sort_dx : Boolean
%   if True - predicted and true centroids are sorted according to their x-coordinates
% Returns:
% -------------------
% sorted_predmat : (N,2) - Matrix
%   The sorted matrix of predicted centroids, same size as sm_TM_RBM_predmat
% sorted_truemat : (M,2) - Matrix
%   The sorted matrix of true centroids, same size as sm_TM_RBM_truemat

%% Code
% If sort_dx is true, the two matrices are sorted according to x-coordinates
    if sort_dx == true
        sorted_predmat = sortrows(sm_TM_RBM_predmat, 1);
        sorted_truemat = sortrows(sm_TM_RBM_truemat, 1);
% If sort_dx is false, the two matrices are sorted according to y-coordinates
    else
        sorted_predmat = sortrows(sm_TM_RBM_predmat, 2);
        sorted_truemat = sortrows(sm_TM_RBM_truemat, 2);
    end
end
