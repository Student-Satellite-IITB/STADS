%% Note
% This script can only work with $4$-stars identified by Feature 
% Extraction block, and therefore has been DEPRECATED!
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Load Files
% Load constants
load('.\Star_Matching\4_Star_Matching\Preprocessing\st_constants_4SM.mat');

% Read - Guide Star Catalogue
st_GD_SC = readmatrix('.\Catalogue\SKY2000\Catalogues\Guide_Star_Catalogue.csv');

% Read - Reference Star Catalogue 
st_RF_SC = readmatrix('.\Star_Matching\4_Star_Matching\Preprocessing\Reference_Star_Catalogue_4SM.csv');

%% Read Input

% Load input file - consists of centroids
load ('.\Star_Matching\4_Star_Matching\Input\st_input.mat');

% Generate body-frame vectors of stars 
st_bi = st_gnrt_bi(fe_output, fe_n_str, Focal_Length); 

%% 4-Star Matching Alogorithm
% Run 4-Star Matching Algorithm
%st_4SM_constants = [st_n_GC, st_M, st_Q, st_DELTA];
%[st_SMM, st_mtch_rows] = st_4SM(st_bi(1:4, :), st_RF_SC, st_4SM_constants);

% Initialize constants
st_4SM_constants = [st_n_GC, st_M, st_Q, st_DELTA];

% Generate input in the format required by 4-Star Matching Algorithm
[st_c_img_AngDst, st_c_fe_IDs] = st_gnrt_ip_4SM(st_bi); 


% Caluculate Star Identification Matrix
st_SIM = st_gnrt_SIM(st_c_img_AngDst, st_RF_SC, st_4SM_constants); 

% Evaluate SIM to find the Star Matched Matrix
[st_SMM, st_mtch_rows]  = st_gnrt_SMM(st_SIM, st_n_GC, st_c_fe_IDs);

%% Generate Output

% Generate output in the format required by Estimation
[st_op_bi, st_op_ri, n_st_strs] = st_gnrt_op_4SM_deprecated(st_SMM, st_bi, st_GD_SC); 
%% Write Output
% Write Output of Star Matching
%save('.\Star_Matching\4_Star_Matching\Output\st_output_deprecated.mat', 'n_st_strs', 'st_mtch_rows', 'st_op_bi', 'st_op_ri', 'st_SIM', 'st_SMM');

% Write Input for Estimation
%save('.\Estimation\Input\es_input_deprecated.mat', 'n_st_strs', 'st_op_bi', 'st_op_ri'); 