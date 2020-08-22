% Preprocessing - Catalogue
% This file preprocesses the SSP_Star_Catalogue.csv and stores it as se_T

% Read the Catalogue from SSP_Star_Catalogue.csv into the Table se_T
se_T = readtable('SSP_Star_Catalogue.csv');
if (se_in.Debug_Run == 1); disp('Preprocessing: Catalogue Successfully Read'); end

% Remove the following columns - 'SKY2000_ID'
se_T = removevars(se_T,{'SKY2000_ID'});
if (se_in.Debug_Run == 1); disp('Preprocessing: Catalogue Trimmed'); end

% Trim Star Catalogue According to Star Magnitude
se_T = se_T(se_T.Vmag <= se_in.Magnitude_Limit, :);
if (se_in.Debug_Run == 1); disp('Preprocessing: Catalogue Modified'); end

% Rename Column Headers / Variable Names
se_T.Properties.VariableNames{'DE'} = 'Dec';
se_T.Properties.VariableNames{'pmRA'} = 'pm_RA';
se_T.Properties.VariableNames{'pmDE'} = 'pm_Dec';
se_T.Properties.VariableNames{'Vmag'} = 'Magnitude';
if (se_in.Debug_Run == 1); disp('Preprocessing: Variables Renamed'); end

% Add unit vectors of stars
se_T.r0 = [cosd(se_T.Dec) .* cosd(se_T.RA), cosd(se_T.Dec) .* sind(se_T.RA), sind(se_T.Dec)];
if (se_in.Debug_Run == 1); disp('Preprocessing: Converted to Cartesian Coordinates'); end

% Save Star Catalogue - Save the preprocessed catalogue in se_SKY2000.mat 
% in Inputs Folder and a copy in the csv format for debugging (Temporary)
save('./Sensor_Model/Preprocessed_Catalogue/se_SKY2000.mat', 'se_T');
if (se_in.Debug_Run == 1); writetable(se_T, './Sensor_Model/Preprocessed_Catalogue/se_SKY2000.csv'); end

fprintf('Preprocessing: Success \n \n');