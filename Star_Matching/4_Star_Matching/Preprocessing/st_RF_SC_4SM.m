%% NOTE:
% -----
% This script should be run only by <<< st_constants_4SM >>> !!!!
% The script will throw an error if run by itself.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Read Preprocessed Star Catalogue
% Read Guide Star Catalogue
st_GD_SC = readmatrix('.\Catalogue\SKY2000\Catalogues\Guide_Star_Catalogue.csv');

% Read - Preprocessed Star Catalogue (which contains the star pairs)
st_PP_SC = readmatrix('.\Catalogue\SKY2000\Catalogues\Preprocessed_Star_Catalogue.csv');

% Extract 'Angular distance - in cos(thetha)' from Preprocessed catalogue
c_AngDst_cos = st_PP_SC(:,3); 

%% Construct K-Vector

% Construct the K-Vector
[K_Vec, st_M, st_Q, ~] = st_gnrt_K_Vec(c_AngDst_cos, st_M_EPS, true); 

%% Create Reference Star Catalogue
st_RF_SC = [st_PP_SC(:, 1:2) , K_Vec]; % Append columns to Reference Star Catalogue

% Create Table
st_RF_SC_table = array2table(st_RF_SC, 'VariableNames',...
                        {'SSP_ID_1', 'SSP_ID_2', 'K_Vec'});

% Number of star pairs (Number of rows - Reference catalogue)
sz = size(st_RF_SC); % Size of REF_CAT
st_n_RC = sz(1); 

% Number of guide stars (Number of rows - Guide catalogue)
sz = size(st_GD_SC); % Size of GD_CAT
st_n_GC = sz(1); 

disp('Done: Preprocessing');

if write_csv == 1
    % Create Reference catalogue
    writetable(st_RF_SC_table,... 
    '.\Star_Matching\4_Star_Matching\Preprocessing\Reference_Star_Catalogue_4SM.csv'); 
    disp('Done: Write Reference Catalogue');
end