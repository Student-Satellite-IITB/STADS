clc
%% Load Files
st_SSP_SC = readtable('.\Star_Matching\Star_Matching_Catalogues\Catalogues\st_SSP_Star_Catalogue.csv');

% Load constants
load('E:\IIT Bombay\SatLab\Star Tracker\Star Matching\STADS\Star_Matching\4_Star_Matching\Preprocessing\Output\st_constants_4SM.mat');
%% Set Parameters
% Noise in centroids
st_add_noise = 1e-3;

% Modify 4SM Constants
st_DELTA_new = 42e-3;
es_N_EST_new = 25;
st_verify_tol_new = 5;

N = 2; % Number of iterations

% Result Arrays
F_correct = zeros(1, N);
F_incorrect = zeros(1, N);
F_total = zeros(1 ,N);
F_fail = zeros(1, N);
F_false_fail = zeros(1, N);

%% Run Test Cases 
for I = 1:N
    
    [st_N_FOV_str, st_FOV_SC] = st_gnrt_rand_FOV_SC(st_SSP_SC, st_consts_opt);
    %% Generate Centroids
    [fe_n_str, fe_output] = st_gnrt_centroids(st_N_FOV_str, st_FOV_SC, st_consts_opt.Focal_Length, st_add_noise);

    save('.\Star_Matching\4_Star_Matching\Input\Test_Cases\st_test_input.mat', 'fe_output', 'fe_n_str');

    %% Run 4-Star Matching Algorithm
    st_main_4SM_v3;

    %% Compare Expected Output with Actual Output
    F_total(I) = st_output.st_N_Verify;
    F_correct(I) = sum( st_output.st_Verify(:,1) == st_output.st_Verify(:, 5) );
    F_incorrect(I) = F_total(I) - F_correct(I);
    
    
    F_fail(I) = st_output.st_N_Fail;    
    F_false_fail(I) = sum( st_output.st_Fail(:,1) == st_output.st_Fail(:, 5) );   
    
end
st_test_main_4SM_v3_plot;