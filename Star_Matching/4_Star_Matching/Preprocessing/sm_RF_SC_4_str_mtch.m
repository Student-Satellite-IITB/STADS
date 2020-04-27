%% NOTE:
% -----
% This script should be run only by <<< sm_constants_4_str_mtch >>> !!!!
% The script will throw an error if run by itself.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Read Preprocessed Star Catalogue
% Read Guide Star Catalogue
GD_SC = readmatrix('.\Catalogue\SKY2000\Catalogues\Guide_Star_Catalogue.csv');

% Read - Preprocessed Star Catalogue (which contains the star pairs)
PP_SC = readmatrix('.\Catalogue\SKY2000\Catalogues\Preprocessed_Star_Catalogue.csv');

% Extract 'Angular distance - in cos(thetha)' from Preprocessed catalogue
c_AngDst_cos = PP_SC(:,3); 

%% Construct K-Vector

% Construct the K-Vector
[K_Vec, sm_M, sm_Q, ~] = sm_gnrt_K_Vec(c_AngDst_cos, sm_M_EPS, true); 

%% Create Reference Star Catalogue
RF_SC = [PP_SC(:, 1:2) , K_Vec]; % Append columns to Reference catalogue

% Create Table
RF_SC_table = array2table(RF_SC, 'VariableNames',...
                        {'SSP_ID_1', 'SSP_ID_2', 'K_Vec'});

% Number of star pairs (Number of rows - Reference catalogue)
sz = size(RF_SC); % Size of REF_CAT
n_rw_RC = sz(1); 

% Number of guide stars (Number of rows - Guide catalogue)
sz = size(GD_SC); % Size of GD_CAT
n_rw_GC = sz(1); 

disp('Done: Preprocessing');

if write_csv == 1
    % Create Reference catalogue
    writetable(RF_SC_table,... 
    '.\Star_Matching\4_Star_Matching\Preprocessing\Reference_Star_Catalogue_4_str_mtch.csv'); 
    disp('Done: Write Reference Catalogue');
end