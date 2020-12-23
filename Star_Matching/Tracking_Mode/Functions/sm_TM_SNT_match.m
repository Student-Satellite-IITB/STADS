function sm_TM_SNT_output = sm_TM_SNT_match(sm_TM_RBM_matchmat, fe_output)
% function to identify the unmatched centroids using the matched stars and the Star Neighbourhood table

%first find which centroids in fe_output have been identified and then find their corresponding star ids from matchmat
%then pick one star id, find neighbours from SNT, eliminate them from the set of neighbours, then find the angular distance of the picked star id with the remaining neighbours
%now find the angular distance between the picked star id and the remaining unmatched centroids from fe_output
%the closest value is taken and the unmatched centroid is assigned with that star id
%keep repeating the process till u reach a angular distance which is greater than any of the neighbours of SNT in which case u need to move to the next matched star and repeat the process
% the above condition may happen if an unmatched centroid is too far away to be included in the neighbours of the beginning matched star.


end