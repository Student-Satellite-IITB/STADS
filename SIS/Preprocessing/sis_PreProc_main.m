
% Preprocessing - Catalogue
% This function preprocesses the SSP_Star_Catalogue.csv and stores it as sis_T

% Read the Catalogue from SSP_Star_Catalogue.csv into the Table sis_T
sis_T = readtable('SSP_Star_Catalogue.csv');
if (sis_input.gen.Debug_Run == 1); disp('Preprocessing: Catalogue Successfully Read'); end

% Remove the following columns - 'SKY2000_ID'
sis_T = removevars(sis_T,{'SKY2000_ID'});
if (sis_input.gen.Debug_Run == 1); disp('Preprocessing: Catalogue Trimmed'); end

% Trim Star Catalogue According to Star Magnitude
sis_T = sis_T(sis_T.Vmag <= sis_input.gen.Magnitude_Limit, :);
if (sis_input.gen.Debug_Run == 1); disp('Preprocessing: Catalogue Modified'); end

% Rename Column Headers / Variable Names
sis_T.Properties.VariableNames{'DE'} = 'Dec';
sis_T.Properties.VariableNames{'pmRA'} = 'pm_RA';
sis_T.Properties.VariableNames{'pmDE'} = 'pm_Dec';
sis_T.Properties.VariableNames{'Vmag'} = 'Magnitude';
if (sis_input.gen.Debug_Run == 1); disp('Preprocessing: Variables Renamed'); end

% Add unit vectors of stars
sis_T.r0 = [cosd(sis_T.Dec) .* cosd(sis_T.RA), cosd(sis_T.Dec) .* sind(sis_T.RA), sind(sis_T.Dec)];
if (sis_input.gen.Debug_Run == 1); disp('Preprocessing: Converted to Cartesian Coordinates'); end

% Save Star Catalogue - Save the preprocessed catalogue in sis_SKY2000.mat 
% in Inputs Folder and a copy in the csv format for debugging (Temporary)
save('./SIS/Preprocessing/sis_SKY2000.mat', 'sis_T');
if (sis_input.gen.Debug_Run == 1); writetable(sis_T, './Sensor_Model/Preprocessed_Catalogue/sis_SKY2000.csv'); end

fprintf('Preprocessing: Success \n \n');

