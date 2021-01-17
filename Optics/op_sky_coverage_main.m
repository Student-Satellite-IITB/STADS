%% Load Constants and the Star Catalogue
se_PP_1_Load_Constants; 
se_PP_2_Catalogue; 

% Paramaters
op_in.es_N_TH = 8; % Minimum number of stars required to estimate attitude with 0.01 deg accuracy
op_in.sm_matching_accuracy = 75; % Accuracy of Star Matching (in %)
op_in.op_N_Images = 60; % Number of images to be taken for each FOV

op_in.iter = 10;
% !!! Note: Run the code by first setting the `op_sys.iter = 10`. 
% 1. Do the above step *atleast four* times till the code becomes optimized by
%    MATLAB and the Elapsed time converges! 
% 2. The code can then be run on the entire sky_coverage table, by setting
%    `op_sys.iter = -1` 
%
% 10 iterations, 60 images/iter ~ 2.2 s 
% 1100 iterations, 60 images/iter ~ (2.2 s) X 110 = 3.3 min 
% (Speedup of ~5x, compared to regular for-loop)


%% Load Boresight Vectors
load('1_uniform_points_1100.mat', 'V');
op_in.v_FOV = V; % Rename boresight vectors

%% Calculate Sky Coverage

[op_sky_coverage_T, op_sky_coverage_val] = ...
    op_gnrt_sky_coverage_T(se_bo, se_er, se_ig, se_in, se_op, se_T, op_in);

%% Save output
% Write the table
writetable(op_sky_coverage_T, '.\Optics\Output\op_sky_coverage_table.csv');

% Save Variables
save('.\Optics\Output\op_sky_coverage.mat', 'op_sky_coverage_T', ...
    'op_sky_coverage_val', 'op_sys');