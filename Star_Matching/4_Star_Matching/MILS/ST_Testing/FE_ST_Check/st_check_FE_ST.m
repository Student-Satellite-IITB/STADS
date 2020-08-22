clc
clear
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Run Star-Matching on Feature-Extraction output
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Load Files
% Load constants
load('.\Star_Matching\4_Star_Matching\Preprocessing\Output\st_constants_4SM.mat');
PIXEL_WIDTH = 4.8e-3;

%% Modify Constants
st_consts_4SM.es_N_EST = 500;
st_consts_4SM.st_DELTA = 8.6e-5;
Trim_Star_ID = st_consts_4SM.st_n_GC;

%% Input
% Folder - Feature Extraction Input
file_base_ip = '.\Star_Matching\4_Star_Matching\MILS\Expected_Input\EXP-OUT-SIM-3-IMAGE-';
file_base_op = '.\Star_Matching\4_Star_Matching\MILS\ST_Testing\FE_ST_Check\';

%% Data Matrix
data_mat = zeros(15,7);
   
%% Run Star Matching
tic
st_textprogressbar('Run Star-Matching');
for idx = 1:15
    st_textprogressbar(idx*100/15);
    %% Input
    file_loc_ip = strcat(file_base_ip , num2str(idx) , '.mat');
    load_data = load(file_loc_ip);  

    % Variable name
    var_name = strcat('arr_exp_final_image_', num2str(idx));
    tmp_fe_output = load_data.(var_name);
    
    % Remove stars not there in Guide Star Catalogue
    cond = tmp_fe_output(:, 1) <= Trim_Star_ID;
    fe_output = tmp_fe_output(cond, :);

    % Change units of centroids
    fe_output = [fe_output(:, 1), fe_output(:, 2:3)*PIXEL_WIDTH];
    sz = size(fe_output);
    fe_n_str = sz(1); clear sz;

    %% 4-Star Matching    
    [st_output, es_input] = st_4SM_main(fe_output, fe_n_str, st_consts_4SM, st_consts_opt, st_catalogues);
    
    % Number of True matches
    st_N_True = sum(  st_output.st_Verify(:,1) == st_output.st_Verify(:,5)  );
    st_N_False = st_output.st_N_Verify - st_N_True;
    
    % Number of missed stars
    st_N_Miss = sum( st_output.st_Fail(:,1) == st_output.st_Fail(:,5) );

    %% Write Output    
    fe_op.fe_n_str = fe_n_str;
    fe_op.fe_output = fe_output;
    
    file_loc_op = strcat(file_base_op , 'st_output_' , num2str(idx) , '.mat');
    save(file_loc_op, 'st_output', 'st_consts_4SM', 'fe_op', 'st_N_True', 'st_N_False', 'st_N_Miss');       

    %%
    % Write data in matrix
    data_mat(idx, :) = [fe_n_str, st_output.st_N_Match, st_output.st_N_Verify, st_N_True, st_N_False, st_N_Miss, st_output.st_iter_total];
end
st_textprogressbar('Done!');
toc
%%
data_table = array2table(data_mat, 'VariableNames', {'fe_n_str', 'st_N_Match', 'st_N_Verify', 'st_N_True', 'st_N_False', 'st_N_Miss', 'st_iter_total'});
data_table.TrackingMode = data_table.st_N_True >= 4;
data_table.GreaterThanDelta = data_table.st_N_True >= 8;

file_loc_op = strcat(file_base_op , 'st_summary_FE_ST_check.mat');
save(file_loc_op, 'data_table', 'Trim_Star_ID');  

%%
sum(data_table.TrackingMode)
sum(data_table.st_N_False)
st_check_FE_ST_plot;