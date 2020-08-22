%% Load Files
% Load constants
load('.\Star_Matching\4_Star_Matching\Preprocessing\Output\st_constants_4SM.mat');

%% Read Input

% Load input file - consists of centroids
%load ('.\Star_Matching\4_Star_Matching\Input\st_input.mat');

% Load test cases
load ('.\Star_Matching\4_Star_Matching\Input\Test_Cases\st_test_input.mat');

% Modify Constants
st_consts_4SM.st_DELTA = st_DELTA_new;
st_consts_4SM.es_N_EST = es_N_EST_new;
st_consts_4SM.st_verify_tol = st_verify_tol_new;

%% 4-Star Matching Alogorithm

tic
[st_output, es_input] = st_4SM_main(fe_output, fe_n_str, st_consts_4SM, st_consts_opt, st_catalogues);
toc

%% Write Output
% Write Output of Star Matching
save('.\Star_Matching\4_Star_Matching\Output\st_output.mat', 'st_output', 'es_input');

% Unpack variables
st_N = es_input.st_N;
st_op_bi = es_input.st_op_bi;
st_op_ri = es_input.st_op_ri;

% Write Input for Estimation
save('.\Estimation\Input\es_input.mat', 'st_N', 'st_op_bi', 'st_op_ri'); 