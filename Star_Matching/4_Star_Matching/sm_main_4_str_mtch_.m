%% Load Files
% Load constants
load('sm_constants_4_str_mtch.mat');

% Read - Guide Star Catalogue
sm_GD_SC = readmatrix('.\Catalogue\SKY2000\Catalogues\Guide_Star_Catalogue.csv');

% Read - Reference Star Catalogue 
sm_RF_SC = readmatrix('.\Star_Matching\4_Star_Matching\Preprocessing\Reference_Star_Catalogue_4_str_mtch.csv');

%% Read Input
load ('sm_input.mat'); % Load input file - consists of centroids

% Generate body-frame vectors of stars 
sm_bi = sm_gnrt_bi(fe_output, n_fe_strs, Focal_Length); 

%% 4-Star Matching Alogorithm
tic
% Generate input in the format required by 4-Star Matching Algorithm
[c_img_AngDst, c_fe_IDs] = sm_gnrt_ip_4_str_mtch(sm_bi, n_fe_strs); 

% Caluculate Star Identification Matrix
sm_SIM = sm_gnrt_SIM(c_img_AngDst, sm_RF_SC, n_rw_GC, sm_M, sm_Q, sm_DELTA); 

% Evaluate SIM to find the Star Matched Matrix
[sm_SMM, sm_mtch_rows]  = sm_gnrt_SMM(sm_SIM, n_rw_GC, c_fe_IDs);

%% Generate Output

% Generate output in the format required by Estimation
[sm_op_bi, sm_op_ri] = sm_gnrt_op_4_str_mtch(sm_SMM, sm_bi, sm_GD_SC); 
toc
%% Write Output
% Write Output of Star Matching
save('.\Star_Matching\4_Star_Matching\Output\sm_output.mat', 'sm_mtch_rows',...
'sm_op_bi', 'sm_op_ri', 'sm_SIM', 'sm_SMM');

% Write Input for Estimation
save('.\Estimation\Input\es_input.mat', 'sm_op_bi', 'sm_op_ri'); 