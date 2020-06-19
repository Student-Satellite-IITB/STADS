clc
clear
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Run Star-Matching on Feature-Extraction output
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Load Files
% Load constants
load('.\Star_Matching\4_Star_Matching\Preprocessing\Output\st_constants_4SM.mat');
PIXEL_WIDTH = 4.8e-3;

% Modify Constants
st_consts_4SM.st_DELTA = 8.6e-5;
st_consts_4SM.es_N_EST = 500;
% st_consts_4SM.st_verify_tol = st_verify_tol_new;

%% Input
% Folder - Feature Extraction Input
T_HOLD = 20;
file_base_ip = strcat('.\Star_Matching\4_Star_Matching\MILS\Input\3b-threshold_', num2str(T_HOLD), '\Image_');
file_base_op = '.\Star_Matching\4_Star_Matching\MILS\Output\';

%% Create matrices to store data
data_mat = zeros(15,7);

%% Run Star Matching
tic
st_textprogressbar('Run Star-Matching');
for idx = 1:15
    st_textprogressbar(idx*100/15);
    %% Input
    file_loc_ip = strcat(file_base_ip , num2str(idx) , '\fe_exp_out.mat');
    load(file_loc_ip, 'arr_out', 'num_stars');
    
    % Fix arr_out units
    arr_out(:, 2:3) = arr_out(:, 2:3)*PIXEL_WIDTH;
    
    % Change variable names
    fe_output = arr_out;
    fe_n_str = num_stars;
    
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
    
    % Star-Matching Output
    file_loc_op = strcat(file_base_op , 'Star_Matching\st_output_' , num2str(idx) , '.mat');
    save(file_loc_op, 'st_output', 'st_consts_4SM', 'fe_op', 'st_N_True', 'st_N_False', 'st_N_Miss');       
    
    % Estimation Input
    file_loc_op = strcat(file_base_op , 'Estimation\es_input_' , num2str(idx) , '.mat');
    save(file_loc_op, 'es_input');
    
    % Write data in matrix
    data_mat(idx, :) = [fe_n_str, st_output.st_N_Match, st_output.st_N_Verify, st_N_True, st_N_False, st_N_Miss, st_output.st_iter_total];
end
st_textprogressbar('Done');
toc

data_table = array2table(data_mat, 'VariableNames', {'fe_n_str', 'st_N_Match', 'st_N_Verify', 'st_N_True', 'st_N_False', 'st_N_Miss', 'st_iter_total'});
data_table.TrackingMode = data_table.st_N_True >= 4;
data_table.GreaterThanDelta = data_table.st_N_True >= 6;

file_loc_op = strcat(file_base_op , 'Star_Matching\st_summary_ST.mat');
save(file_loc_op, 'data_table', 'st_consts_4SM', 'st_consts_opt', 'T_HOLD'); 
sum(data_table.TrackingMode)
sum(data_table.GreaterThanDelta)

%%%%% PLOT Results
st_MILS_plot;