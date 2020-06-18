clc
clear
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Run Star-Macthing on Sensor Modelling Output
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Load Files
% Load constants
load('.\Star_Matching\4_Star_Matching\Preprocessing\Output\st_constants_4SM.mat');
PIXEL_WIDTH = 4.8e-3;
Focal_Length = 25;

% Modify Constants
st_consts_4SM.st_DELTA = 8.6e-5;
% st_consts_4SM.es_N_EST = 10;
% st_consts_4SM.st_verify_tol = st_verify_tol_new;

%% Input
% Folder - Feature Extraction Input
file_base_ip = '.\Star_Matching\4_Star_Matching\MILS\Expected_Input\Simulation_3\Image_';
file_base_op = '.\Star_Matching\4_Star_Matching\MILS\ST_Testing\SE_ST_Check\';


%% Create matrices to store data
data_mat = zeros(15, 5);

%% Run Star Matching
tic
for i = 1:15
    %% Input
    file_loc_ip = strcat(file_base_ip , num2str(i) , '\se_Verification_' ,  num2str(i) , '.mat');
    load(file_loc_ip);
    
    % Remove stars not there in Guide Star Catalogue
    cond = se_T_Verification.SSP_ID <= st_consts_4SM.st_n_GC;
    se_T_Verification = se_T_Verification(cond, :);    
    
    %% Actual Centroids
    fe_output = [se_T_Verification.SSP_ID, se_T_Verification.Sensor_X*PIXEL_WIDTH, se_T_Verification.Sensor_Y*PIXEL_WIDTH];
    sz = size(fe_output);
    fe_n_str = sz(1); clear sz;
   
    %% 4-Star Matching    
    [st_output, es_input] = st_4SM_main(fe_output, fe_n_str, st_consts_4SM, st_consts_opt, st_catalogues);

    %% Write Output    
    fe_op.fe_n_str = fe_n_str;
    fe_op.fe_output = fe_output;
    
    file_loc_op = strcat(file_base_op , 'st_output_' , num2str(i) , '.mat');
    save(file_loc_op, 'st_output', 'es_input', 'st_consts_4SM', 'fe_op');   
    
    % Number of True matches
    st_N_True = sum(  st_output.st_Verify(:,1) == st_output.st_Verify(:,5)  );

    % Write data in matrix
    data_mat(i, :) = [fe_n_str, st_output.st_N_Match, st_output.st_N_Verify, st_N_True, st_output.st_iter_total];
end
toc
%%
data_table = array2table(data_mat, 'VariableNames', {'fe_n_str', 'st_N_Match', 'st_N_Verify', 'st_N_True', 'st_iter_total'});
data_table.TrackingMode = data_table.st_N_True >= 4;
data_table.GreaterThanDelta = data_table.st_N_True >= 8;

file_loc_op = strcat(file_base_op , 'st_summary_SE_ST_check.mat');
save(file_loc_op, 'data_table');  

%%
sum(data_table.TrackingMode)
sum(data_table.GreaterThanDelta)