%% Load Files
% Load constants
load('.\Star_Matching\4_Star_Matching\Preprocessing\Output\st_constants_4SM.mat');

% Modify Constants
st_consts_4SM.st_DELTA = 42e-3;
% st_consts_4SM.es_N_EST = 10;
% st_consts_4SM.st_verify_tol = st_verify_tol_new;

%% Input
% Folder - Feature Extraction Input
file_base_ip = '.\Star_Matching\4_Star_Matching\MILS\Input\';
file_base_op = '.\Star_Matching\4_Star_Matching\MILS\Output\';

%% Create matrices to store data
data_mat = zeros(15, 6);

%% Run Star Matching
tic
for idx = 1:15
    %% Input
    file_loc_ip = strcat(file_base_ip , 'image_' , num2str(idx) , '_centroids.mat');
    load(file_loc_ip);
    
    % Change variable names
    fe_output = arr_centroids;
    fe_n_str = num_stars;
    
    %% 4-Star Matching    
    [st_output, es_input] = st_4SM_main(fe_output, fe_n_str, st_consts_4SM, st_consts_opt, st_catalogues);
    
    %% Write Output    
    file_loc_op = strcat(file_base_op , 'st_output_' , num2str(idx) , '.mat');
    save(file_loc_op, 'st_output', 'es_input', 'st_consts_4SM');    
    
    % Write data in matrix
    data_mat(idx, :) = [fe_n_str, st_output.st_N_Match, st_output.st_N_UnMatch, st_output.st_N_Verify, st_output.st_N_Fail, st_output.st_iter_total];
end
toc

data_table = array2table(data_mat, 'VariableNames', {'fe_n_str', 'st_N_Match', 'st_N_UnMatch', 'st_N_Verify', 'st_N_Fail', 'st_iter_total'});
data_table.TrackingMode = data_table.st_N_Verify >= 4;
data_table.GreaterThanDelta = data_table.st_N_Verify >= 8;

save('.\Star_Matching\4_Star_Matching\MILS\Output\st_summary.mat', 'data_table');
sum(data_table.TrackingMode)
sum(data_table.GreaterThanDelta)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Check for different DELTA values
% N = 500;
% DELTA_arr = linspace(3.5e-3, 5e-2, N);
% %DELTA = linspace(1e-5, 1e-2, N)
% 
% c_TrackingMode = zeros(N,1);
% c_GreaterThanDelta = zeros(N,1);
% 
% jdx = 1;
% 
% for DELTA = DELTA_arr
%     fprintf('%d | %d \n',jdx, DELTA)
%     %% Modify Constants
%     st_consts_4SM.st_DELTA = DELTA;
%     % st_consts_4SM.es_N_EST = es_N_EST_new;
%     % st_consts_4SM.st_verify_tol = st_verify_tol_new;
% 
%     %% Create matrices to store data
%     data_mat = zeros(15, 6);
%     %% Run Star Matching
%     for idx = 1:15
%         %% Input
%         file_loc_ip = strcat(file_base_ip , 'image_' , num2str(idx) , '_centroids.mat');
%         load(file_loc_ip);
% 
%         % Change variable names
%         fe_output = arr_centroids;
%         fe_n_str = num_stars;
% 
%         %% 4-Star Matching    
%         [st_output, es_input] = st_4SM_main(fe_output, fe_n_str, st_consts_4SM, st_consts_opt, st_catalogues);
% 
%         % Write data in matrix
%         data_mat(idx, :) = [fe_n_str, st_output.st_N_Match, st_output.st_N_UnMatch, st_output.st_N_Verify, st_output.st_N_Fail, st_output.st_iter_total];
%     end
%     
%     data_table = array2table(data_mat, 'VariableNames', {'fe_n_str', 'st_N_Match', 'st_N_UnMatch', 'st_N_Verify', 'st_N_Fail', 'st_iter_total'});
%     data_table.TrackingMode = data_table.st_N_Verify >= 4;
%     data_table.GreaterThanDelta = data_table.st_N_Verify >= 8;
%     
%     c_TrackingMode(jdx) = sum(data_table.TrackingMode);
%     c_GreaterThanDelta(jdx) = sum(data_table.GreaterThanDelta);
%     jdx = jdx + 1;
%     
%     
% end
% %%
% save('.\Star_Matching\4_Star_Matching\MILS\Output\st_DELTA_summary_2.mat', 'DELTA_arr', 'c_GreaterThanDelta', 'c_TrackingMode');
% 
% st_MILS_plot;