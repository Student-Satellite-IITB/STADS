%% Read SSP Star Catalogue
SSP_SC = readtable('.\Catalogue\SKY2000\Catalogues\SSP_Star_Catalogue.csv');

%% Create Guide Star Catalogue

% Extract stars brighter than Limiting Magnitude
Magnitude_Limit = 6;
cond = SSP_SC.Vmag <= Magnitude_Limit; % Set up condition

tmp = SSP_SC(cond , :);
 
% Generate cartesian unit vectors
unit_vect = rowfun(@ca_RA_DE_2_CartVect, tmp, 'InputVariables', [3,4], 'OutputVariableNames', {'X', 'Y', 'Z'});

GD_SC = [tmp(:, 1), unit_vect]; % Append Columns

% Write Table
writetable(GD_SC, '.\Catalogue\SKY2000\Catalogues\Guide_Star_Catalogue.csv');