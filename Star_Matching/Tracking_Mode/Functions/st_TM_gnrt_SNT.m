sfunction [st_TM_SNT] = st_TM_gnrt_SNT (st_TM_SNT_R, is_degree, st_GD_SC, st_PP_SC)
%% Generates the Star Neighbourhood Matrix for Tracking Mode Algorithm. 
% Parameters 
% ---------------
% st_TM_SNT_R : double
%     The radius used to construct the SNT. 
% is_degree : Boolean
%     If true -> Implies the radius is in degrees. 
% load the guide star and the preprocessed catalogues. 

% Returns: 
% ---------------
% st_TM_SNT : (5060, N) - Matrix
%     The Star Neighbourhood Matrix 
%% Code
%% Initialise SNT
st_TM_SNT = [];

%% Construct SNT
for st_star_ID = 1:size(st_GD_SC, 1)
    % Find Neighbour stars for each guide star
    st_TM_SNT_star_ID = st_TM_SNT_neighbours(st_star_ID, st_PP_SC, st_TM_SNT_R, is_degree);
    % Add padding to SNT_star_ID
    st_TM_SNT = st_TM_SNT_padding(st_TM_SNT_star_ID, st_TM_SNT);
end
end
