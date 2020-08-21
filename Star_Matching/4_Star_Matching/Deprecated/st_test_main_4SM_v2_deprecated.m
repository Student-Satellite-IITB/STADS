st_SSP_SC = readtable('.\Star_Matching\Star_Matching_Catalogues\Catalogues\st_SSP_Star_Catalogue.csv');
%% Set Parameters
clc
% Optic System Constants

FOV_Circular = 17.89; % Circular FOV - in degrees
FOV_Circular = FOV_Circular * (1 + 0.05) * 0.48; % Account for 5% safety factor

Magnitude_Limit = 6;
Focal_Length = 25;

% Noise in centroids
st_add_noise = 0.001;

% Modify 4SM Constants
st_DELTA_new = 1e-4;
es_N_EST_new = 25;
st_verify_tol_new = 5;

N = 1; % Number of iterations

% Result Arrays
F_correct = zeros(1, N);
F_incorrect = zeros(1, N);
F_total = zeros(1 ,N);
F_fail = zeros(1, N);
F_false_fail = zeros(1, N);

[st_N_FOV_str, st_FOV_SC] = st_gnrt_rand_FOV_SC(st_SSP_SC, FOV_Circular, Magnitude_Limit);
[fe_n_str, fe_output] = st_gnrt_centroids(st_N_FOV_str, st_FOV_SC, Focal_Length, st_add_noise);
save('.\Star_Matching\4_Star_Matching\Input\Test_Cases\st_test_input.mat', ...
    'fe_output', 'fe_n_str');

%% Compare Different FOVs
% for I = 1:N
%     
%     [st_N_FOV_str, st_FOV_SC] = st_gnrt_rand_FOV_SC(st_SSP_SC, FOV_Circular, Magnitude_Limit);
%     %% Generate Centroids
%     [fe_n_str, fe_output] = st_gnrt_centroids(st_N_FOV_str, st_FOV_SC, Focal_Length, st_add_noise);
% 
%     save('.\Star_Matching\4_Star_Matching\Input\Test_Cases\st_test_input.mat', ...
%     'fe_output', 'fe_n_str');
% 
%     %% Run 4-Star Matching Algorithm
%     st_main_4SM_v2;
% 
%     %% Compare Expected Output with Actual Output
%     F_total(I) = st_N_Verify;
%     F_correct(I) = sum( st_Verify(:,1)==st_Verify(:, 5) );
%     F_incorrect(I) = F_total(I) - F_correct(I);
%     
%     
%     F_fail(I) = st_N_Fail;    
%     F_false_fail(I) = sum( st_Fail(:,1)==st_Fail(:, 5) );   
%     
% end
% st_test_main_4SM_v2_plot;
clear