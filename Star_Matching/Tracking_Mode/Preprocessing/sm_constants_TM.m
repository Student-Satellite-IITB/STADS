%% Generate Constants

sm_consts_TM.sm_TM_SNT_R = 1.5; % Radius for star neighbourhood table (in degrees)

write_csv = 1; % Writes Star Neighbourhood Table if 1

%% Run Preprocessing
sm_TM_SNT_main;

% Save the star catalogues
sm_catalogues.sm_GD_SC = sm_GD_SC;
sm_catalogues.sm_PP_SC = sm_PP_SC;

%% Constants

% Save constants

save ('./Star_Matching/Tracking_Mode/Preprocessing/Output/sm_constants_TM.mat',...
    'sm_consts_TM', 'sm_TM_SNT', 'sm_catalogues');

disp('Done : Write Constants');