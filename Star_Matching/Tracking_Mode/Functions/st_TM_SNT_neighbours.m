function [st_TM_SNT_star_ID] = st_TM_SNT_neighbours (st_star_ID, st_PP_SC, st_TM_SNT_R, is_degree )
%% Finds the Star Neighbours around st_star_id within a radius of st_TM_SNT_R
% Parameters:
% ---------------
% st_star_ID : int
%    Star ID around which neighbours have to be found. 
% st_PP_SC : (N, 4) - Matrix 
%    The preprocessed star catalogue. 
% st_TM_SNT_R : double
%   The radius around each star in which star neighbours will be searched. 

% Return:
% ----------------
% st_TM_SNT_star_ID : (1, N) - Matrix
%     The star neighbours of st_star_ID

%% Finding the star id in the preprocessed star catalogue
tmp_neighbours_1 = st_PP_SC(find(st_PP_SC(:,1)==st_star_ID),:); % Star IDs in the 1st column of st_PP_SC
tmp_neighbours_2 = st_PP_SC(find(st_PP_SC(:,2)==st_star_ID),:); % Star IDs in the 2nd column of st_PP_SC
    
%% Initialise st_TM_SNT_star_ID with st_star_ID
st_TM_SNT_star_ID = [st_star_ID];

%% Add star neighbours to st_TM_SNT_star_ID 
if is_degree == true 
for tmp_idx = 1:size(tmp_neighbours_1, 1)
    if tmp_neighbours_1(tmp_idx,4)<=st_TM_SNT_R % Check if angular distance is less than st_TM_SNT_R
        st_TM_SNT_star_ID = [st_TM_SNT_star_ID tmp_neighbours_1(tmp_idx, 2)];
    end
end
for tmp_idx = 1:size(tmp_neighbours_2, 1)
    if tmp_neighbours_2(tmp_idx,4)<=st_TM_SNT_R % Check if angular distance is less than st_TM_SNT_R
        st_TM_SNT_star_ID = [st_TM_SNT_star_ID tmp_neighbours_2(tmp_idx, 1)];
    end
end

elseif is_degree == false
for tmp_idx = 1:size(tmp_neighbours_1, 1)
if tmp_neighbours_1(tmp_idx,3)>st_TM_SNT_R  % Check if cosine of angular distance is greater than st_TM_SNT_R
   st_TM_SNT_star_ID = [st_TM_SNT_star_ID tmp_neighbours_1(tmp_idx, 2)];
end
end
for tmp_idx = 1:size(tmp_neighbours_2, 1)
    if tmp_neighbours_2(tmp_idx,3)>st_TM_SNT_R % Check if cosine of angular distance is greater than st_TM_SNT_R
        st_TM_SNT_star_ID = [st_TM_SNT_star_ID tmp_neighbours_2(tmp_idx, 1)];
    end
end
end

end


