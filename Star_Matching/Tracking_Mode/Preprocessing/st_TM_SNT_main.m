%% NOTE:
% -----
% This script should be run only by <<< st_constants_TM >>> !!!!
% The script will throw an error if run by itself.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Read Star Catalogues

% Read - Guide Star Catalogue
st_GD_SC = readmatrix('./Star_Matching/Star_Matching_Catalogues/Catalogues/st_Guide_Star_Catalogue.csv');

% Read - Preprocessed Star Catalogue (which contains the star pairs)
st_PP_SC = readmatrix('./Star_Matching/Star_Matching_Catalogues/Catalogues/st_Preprocessed_Star_Catalogue.csv');


%% Construct the Star Neighbourhood Table 
st_TM_SNT =  st_TM_gnrt_SNT (st_consts_TM.st_TM_SNT_R, true , st_GD_SC, st_PP_SC);

% Create Table
st_TM_SNT_table = array2table(st_TM_SNT);

disp('SNT Created');

if write_csv == 1
    % Create SNT (in csv format)
    writetable(st_TM_SNT_table, ...
        './Star_Matching/Tracking_Mode/Preprocessing/Output/st_Star_Neighbourhood_Table_TM.csv');
    disp('Done: Write Star Neighbourhood Table');
end

