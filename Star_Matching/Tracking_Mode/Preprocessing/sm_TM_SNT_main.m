%% NOTE:
% -----
% This script should be run only by <<< sm_constants_TM >>> !!!!
% The script will throw an error if run by itself.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Read Star Catalogues

% Read - Guide Star Catalogue
sm_GD_SC = readmatrix('./Star_Matching/Star_Matching_Catalogues/Catalogues/sm_Guide_Star_Catalogue.csv');

% Read - Preprocessed Star Catalogue (which contains the star pairs)
sm_PP_SC = readmatrix('./Star_Matching/Star_Matching_Catalogues/Catalogues/sm_Preprocessed_Star_Catalogue.csv');


%% Construct the Star Neighbourhood Table 
% sm_TM_SNT =  sm_TM_gnrt_SNT (sm_consts_TM.sm_TM_SNT_R, true , sm_GD_SC, sm_PP_SC);
sm_TM_SNT =  sm_TM_gnrt_SNT (sm_consts_TM, sm_catalogues, true);

% Create Table
sm_TM_SNT_table = array2table(sm_TM_SNT);

disp('SNT Created');

if write_csv == 1
    % Create SNT (in csv format)
    writetable(sm_TM_SNT_table, ...
        './Star_Matching/Tracking_Mode/Preprocessing/Output/sm_Star_Neighbourhood_Table_TM.csv');
    disp('Done: Write Star Neighbourhood Table');
end

