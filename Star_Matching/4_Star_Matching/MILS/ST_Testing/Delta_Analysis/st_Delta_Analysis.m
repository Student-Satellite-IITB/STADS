clc
clear
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Find the optimum value for the DELTA parameter of the Lost-in-Space Mode 
% of Star-Matching using the output of Feature Extraction, which has the 
% true SSP-ID of each star as the corresponding Feature Extraction ID
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Load Files
% Load constants
load('.\Star_Matching\4_Star_Matching\Preprocessing\Output\st_constants_4SM.mat');
PIXEL_WIDTH = 4.8e-3;

%% Modify Constants
st_consts_4SM.es_N_EST = 25;

%% Input
% Folder - Feature Extraction Input
file_base_ip = '.\Star_Matching\4_Star_Matching\MILS\Expected_Input\EXP-OUT-SIM-3-IMAGE-';
file_base_op = '.\Star_Matching\4_Star_Matching\MILS\ST_Testing\Delta_Analysis\';

%% Check for different DELTA values
N = 600;
DELTA_arr = linspace(1e-5, 0.75, N);

c_TrackingMode = zeros(N,1);
c_GreaterThanDelta = zeros(N,1);

%% For-Loop
jdx = 1;
for DELTA = DELTA_arr
    fprintf('%d It || %d DELTA \n',jdx, DELTA) % Print Progress
    
    %% Modify DELTA
    st_consts_4SM.st_DELTA = DELTA;    

    %% Create matrices to store data
    data_mat = zeros(15, 5);
    
    %% Run Star Matching
    for idx = 1:15
        %% Input
        file_loc_ip = strcat(file_base_ip , num2str(idx) , '.mat');
        load_data = load(file_loc_ip);  
        
        % Variable name
        var_name = strcat('arr_exp_final_image_', num2str(idx));
        tmp_fe_output = load_data.(var_name);
        %%
        % Remove stars not there in Guide Star Catalogue
        cond = tmp_fe_output(:, 1) <= st_consts_4SM.st_n_GC;
        fe_output = tmp_fe_output(cond, :);
        
        %% Change units of centroids
        fe_output = [fe_output(:, 1), fe_output(:, 2:3)*PIXEL_WIDTH];
        sz = size(fe_output);
        fe_n_str = sz(1); clear sz;

        %% 4-Star Matching    
        [st_output, es_input] = st_4SM_main(fe_output, fe_n_str, st_consts_4SM, st_consts_opt, st_catalogues);

        % Number of True matches
        st_N_True = sum(  st_output.st_Verify(:,1) == st_output.st_Verify(:,5)  );

        % Write data in matrix
        data_mat(idx, :) = [fe_n_str, st_output.st_N_Match, st_output.st_N_Verify, st_N_True, st_output.st_iter_total];
    end
    
    data_table = array2table(data_mat, 'VariableNames', {'fe_n_str', 'st_N_Match', 'st_N_Verify', 'st_N_True', 'st_iter_total'});
    data_table.TrackingMode = data_table.st_N_True >= 4;
    data_table.GreaterThanDelta = data_table.st_N_True >= 8;
    
    c_TrackingMode(jdx) = sum(data_table.TrackingMode);
    c_GreaterThanDelta(jdx) = sum(data_table.GreaterThanDelta);
    jdx = jdx + 1;
    
    
end
%%
file_loc_op = strcat(file_base_op , 'st_DELTA_summary_coarse.mat');
save(file_loc_op, 'DELTA_arr', 'c_GreaterThanDelta', 'c_TrackingMode');

st_Delta_Analysis_plot;