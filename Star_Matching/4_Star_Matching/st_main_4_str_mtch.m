%% Load Files
% Load constants
load('st_constants_4_str_mtch.mat');

% Read - Guide Star Catalogue
st_GD_SC = readmatrix('.\Catalogue\SKY2000\Catalogues\Guide_Star_Catalogue.csv');

% Read - Reference Star Catalogue 
st_RF_SC = readmatrix('.\Star_Matching\4_Star_Matching\Preprocessing\Reference_Star_Catalogue_4_str_mtch.csv');

%% Read Input
load ('st_input.mat'); % Load input file - consists of centroids

% Generate body-frame vectors of stars 
st_bi = st_gnrt_bi(fe_output, n_fe_strs, Focal_Length); 

%% 4-Star Matching Alogorithm
% Generate input in the format required by 4-Star Matching Algorithm
[c_img_AngDst, c_fe_IDs] = st_gnrt_ip_4_str_mtch(st_bi, n_fe_strs); 

% Caluculate Star Identification Matrix
st_SIM = st_gnrt_SIM(c_img_AngDst, st_RF_SC, n_rw_GC, st_M, st_Q, st_DELTA); 

% Evaluate SIM to find the Star Matched Matrix
[st_SMM, st_mtch_rows]  = st_gnrt_SMM(st_SIM, n_rw_GC, c_fe_IDs);

%% Generate Output

% Generate output in the format required by Estimation
[st_op_bi, st_op_ri, n_st_strs] = st_gnrt_op_4_str_mtch(st_SMM, st_bi, st_GD_SC); 
%% Write Output
% Write Output of Star Matching
save('.\Star_Matching\4_Star_Matching\Output\st_output.mat', 'n_st_strs', 'st_mtch_rows',...
'st_op_bi', 'st_op_ri', 'st_SIM', 'st_SMM');

% Write Input for Estimation
save('.\Estimation\Input\es_input.mat', 'n_st_strs', 'st_op_bi', 'st_op_ri'); 