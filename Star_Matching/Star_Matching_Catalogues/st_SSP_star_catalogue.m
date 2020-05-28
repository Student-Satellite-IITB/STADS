%% Read SSP Star Catalogue
SSP_SC = readtable('.\Catalogue\SKY2000\Catalogues\SSP_Star_Catalogue.csv');

%% Generate Cartesian Unit Vectors

% Extract stars brighter than Limiting Magnitude
Magnitude_Limit = 6;
cond = SSP_SC.Vmag <= Magnitude_Limit; % Set up condition

tmp = SSP_SC(cond , :); 

tic
% Generate cartesian unit vectors
unit_vect = rowfun(@ca_RA_DE_2_CartVect, tmp, 'InputVariables', [3,4], ...
    'OutputVariableNames', {'X', 'Y', 'Z'});
toc
%%
st_SSP = [tmp, unit_vect]; % Append Columns
%%
% Write Table
writetable(st_SSP, '.\Star_Matching\Star_Matching_Catalogues\Catalogues\st_SSP_Star_Catalogue.csv');