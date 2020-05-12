%% Read SKY2000 Catalogue
SKY_C = readtable('.\Catalogue\SKY2000\Catalogues\SKY2000.csv');

%% Create Master Star Catalogue
skip = 3; %Skip first <skip> rows

% SKY2000_ID
clm = SKY_C.SKY2000(skip:end);
tmp1 = cell2table(clm, 'VariableNames', {'SKY2000_ID'}); % Initialize Modified Star Catalogue with SKY2000_ID

% RA_h, RA_m, RA_s
clm = SKY_C.RAJ2000(skip:end);
clm_new = split(clm); % Split at whitespaces
tmp2 = cell2table(clm_new, 'VariableNames', {'RA_h', 'RA_m', 'RA_s'}); 

% DE_d, DE_m, DE_s 
clm = SKY_C.DEJ2000(skip:end);
clm_new = split(clm);
tmp3 = cell2table(clm_new, 'VariableNames', {'DE_d', 'DE_m', 'DE_s'} );

% Magnitude
clm = SKY_C.Vmag(skip:end);
tmp4 = cell2table(clm, 'VariableNames', {'Vmag'});

%Other Columns
tmp5 =  SKY_C(skip:end,[4,5,7]);

% Append all columns
M_SC = [tmp1, tmp2, tmp3, tmp4, tmp5];

% Drop B-V
M_SC = M_SC(:, 1:end - 1);

% Write Table
writetable(M_SC, '.\Catalogue\SKY2000\Catalogues\Master_Star_Catalogue.csv');

%% Create SSP Star Catalogue

% Read Master Star Catalogue
M_SC = readtable('.\Catalogue\SKY2000\Catalogues\Master_Star_Catalogue.csv');
sz = size(M_SC);
N = sz(1); % Number of rows in Master Star Catalogue

% Declination to degrees conversion
tmp1 = rowfun(@ca_DMS2degrees, M_SC, 'InputVariables', [5,6,7], 'OutputVariableNames', {'DE'});

% Right-Ascension to degrees conversion
tmp2 = rowfun(@ca_HMS2degrees, M_SC, 'InputVariables', [2,3,4], 'OutputVariableNames', {'RA'});

SSP_SC = [M_SC(:,1), tmp2, tmp1, M_SC(:, 8:10)]; % Append all columns
SSP_SC = sortrows(SSP_SC,'Vmag','ascend'); % Sort based on VMag column

% Unit-Vectors - [X, Y, Z]
unit_vect = rowfun(@ca_RA_DE_2_CartVect, SSP_SC, 'InputVariables', [2,3], 'OutputVariableNames', {'X', 'Y', 'Z'});
SSP_SC = [SSP_SC, unit_vect];

%% Append SSP_ID
val = transpose(1:N);
SSP_ID = array2table(val, 'VariableNames', {'SSP_ID'});

SSP_SC = [SSP_ID, SSP_SC]; % Append Column

% Write Table
writetable(SSP_SC, '.\Catalogue\SKY2000\Catalogues\SSP_Star_Catalogue.csv');