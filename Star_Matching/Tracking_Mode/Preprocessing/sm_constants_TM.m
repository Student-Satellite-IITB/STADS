%% Generate Constants

sm_consts_TM.sm_TM_SNT_R = 1.5; % Radius for star neighbourhood table (in degrees)
sm_consts_TM.sm_TM_RBM_R = 1.5; % Radius for Radius based matching algorithm (in degrees)
sm_consts_TM.sm_TM_CP_F = 10; % Focal length of the star sensor (in cm)
sm_consts_TM.sm_TM_FOV_x = 10; % length of the sensor FOV (-5,5)
sm_consts_TM.sm_TM_FOV_y = 10; % breadth of the sensor FOV (-5,5)
sm_consts_TM.sm_TM_Nth = 8; % Minimum number of stars required for reasonable accuracy in attitude output


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

disp('Done: Write Constants');
