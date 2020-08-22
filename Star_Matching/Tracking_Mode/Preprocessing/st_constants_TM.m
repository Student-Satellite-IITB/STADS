%% Generate Constants

st_consts_TM.st_TM_SNT_R = 1.5; % Radius for star neighbourhood table (in degrees)

write_csv = 1; % Writes Star Neighbourhood Table if 1

%% Run Preprocessing
st_TM_SNT_main;

% Save the star catalogues
st_catalogues.st_GD_SC = st_GD_SC;
st_catalogues.st_PP_SC = st_PP_SC;

%% Constants

% Save constants

save ('./Star_Matching/Tracking_Mode/Preprocessing/Output/st_constants_TM.mat',...
    'st_consts_TM', 'st_TM_SNT', 'st_catalogues');

disp('Done : Write Constants');