%-----------------------------CONSTANTS FILE-----------------------------%
%
% Excecute this MATLAB script to generate the constants.mat file necessary
% to run Star Image Simulation and/or Model-in-Loop Simulation
%
%% Star Image Simulations Constants
SIS_const.in.Debug_Run = 1; % Debug Run or Silent Run


SIS_const.in.Magnitude_Limit = 6.5; % Sensor Model Star Magnitude Limit
SIS_const.in.No_Boresight_Inputs = 100; % Number of Boresight Inputs in se_boresight_inputs.xlsx


SIS_const.op.CMOS.Length_Pix = 808;        % Pixels
SIS_const.op.CMOS.Width_Pix =  608;        % Pixels
SIS_const.op.CMOS.Pixel_Size =   4.8000e-06 ; % mm -> m
SIS_const.op.CMOS.Defocus =      0; % mm -> m
SIS_const.op.Lens.Focal_Length =  0.036; % mm -> m
SIS_const.op.Lens.Diameter =     0.020  ; % mm -> m
SIS_const.op.CMOS.Length =     SIS_const.op.CMOS.Length_Pix * SIS_const.op.CMOS.Pixel_Size;      % m
SIS_const.op.CMOS.Width =      SIS_const.op.CMOS.Width_Pix * SIS_const.op.CMOS.Pixel_Size;       % m
SIS_const.op.CMOS.Diagonal =   sqrt(SIS_const.op.CMOS.Length ^ 2 + SIS_const.op.CMOS.Width ^ 2); % m
SIS_const.op.FOV.Length =      2 * atand(SIS_const.op.CMOS.Length / (2 * SIS_const.op.Lens.Focal_Length));   % Degrees
SIS_const.op.FOV.Width =       2 * atand(SIS_const.op.CMOS.Width / (2 * SIS_const.op.Lens.Focal_Length));    % Degrees
SIS_const.op.FOV.Circular =    2 * atand(SIS_const.op.CMOS.Diagonal / (2 * SIS_const.op.Lens.Focal_Length)); % Degrees

SIS_const.ig.Pixel_Spread =    2;        % Pixels
SIS_const.ig.Capture_Rate =    4;        % Hz
SIS_const.ig.Eta =             0.56; % / 100;  % In Decimals
SIS_const.ig.Gain =            0.096;        % In LSB10 / electron
SIS_const.ig.Exposure_Time =   0.2;        % Seconds
SIS_const.ig.MTF =             0.62; % / 100;  % In Decimals
SIS_const.ig.Full_Well =       10000;        % Electrons - May be used later
SIS_const.ig.Lens_Eff =        0.6; % / 100;  % In Decimals
SIS_const.ig.Gauss_Sigma =   (SIS_const.ig.Pixel_Spread * sqrt(2)) / 3;
SIS_const.ig.C_1 = 3640 * 1.51e7 * 0.16 * SIS_const.ig.Exposure_Time * (pi * SIS_const.op.Lens.Diameter ^ 2 / 4) * SIS_const.ig.MTF * SIS_const.ig.Eta * SIS_const.ig.Lens_Eff;
SIS_const.ig.C_2 = 100 ^ 0.2;
%-------------------------END-------------------------%


%% Feature Extraction Constants

FE_const.THRESHOLD = 3;%these will be changed for testing
FE_const.STAR_MIN_PIXEL = 3;
FE_const.STAR_MAX_PIXEL = 150;

FE_const.MAX_STARS = 100;%region growth
FE_const.SKIP_PIXELS = 2;%this will be changed for testing
FE_const.NUM_REGIONS = 50;

FE_const.LENGTH = 808;
FE_const.BREADTH = 608;
FE_const.PIXEL_SIZE = 4.8e-6;
FE_const.NUM_RANGES_ROW = 20;
FE_const.NUM_MERGE_LINE = 10;
FE_const.NUM_TAGS_MERGE = 10;

FE_const.NUM_FINAL_TAGS=50;%tagging
FE_const.NUM_TAGS_PER_REGION= 21;
FE_const.PIXEL_WIDTH = 0.0048;

%WASN'T DEFINED EARLIER 
FE_const.MIN_PIXELS = 3;
FE_const.MAX_PIXELS = 150;
%-------------------------END-------------------------%


%% Star Matching Constants

SM_const.FOV_CIRCULAR = SIS_const.op.FOV.Circular; % Circular Field-of-View - in degrees
SM_const.MAG_LIMIT = SIS_const.in.Magnitude_Limit; % Limiting Magnitude
SM_const.FOCAL_LENGTH = SIS_const.op.Lens.Focal_Length;  % Focal Length of optics system - in mm


SM_const.LIS.CONST_4SM.DELTA = 1e-4; % Value of Delta Constant
SM_const.LIS.CONST_4SM.M_EPS = 2.22*10e-16; % Machine epsilon
SM_const.LIS.CONST_4SM.VERIFY_TOL = 2; % Verification Step - Tolerance Value (in percentage)

SM_const.TM.sm_TM_SNT_R = 1.5; % Radius for star neighbourhood table (in degrees)
SM_const.TM.sm_TM_RBM_R = 0.0015; % Radius for Radius based matching algorithm (in degrees)
SM_const.TM.sm_TM_CP_F = 10; % Focal length of the star sensor (in cm)
SM_const.TM.sm_TM_FOV_x = 10; % length of the sensor FOV (-5,5)
SM_const.TM.sm_TM_FOV_y = 10; % breadth of the sensor FOV (-5,5)
SM_const.TM.sm_TM_Nth = 8; % Minimum number of stars required for reasonable accuracy in attitude output

% Number of body and inertial frame vectors required by Estimation block to
% provide attitude with the required accuracy
SM_const.N_TH = 30;

% Total number of iterations allowed for Star-Matching
SM_const.LIS.CONST_4SM.ITER_MAX = 200;
%-------------------------END-------------------------%


%% Estimation Constants
ES_const.es_epsilon = 1.0000e-03;
ES_const.es_q_bi_prev = [0.5000;0.5000;0.5000;0.5000];
ES_const.es_seq_error = 0.1;

%-------------------------END-------------------------%


%% Save constants.mat file
% This code should not be tampered with!!!

% Generates the path where this constant.m file is stored
%%%% Eg: .\home\user\Simulation_1\constant.m %%%%
currentFolder = matlab.desktop.editor.getActiveFilename; 
%%
% Modifies the path name, so that the corresponding *.mat file can be
% stored
%%%% Eg: .\home\user\Simulation_1\simulation_constants.mat %%%%
fileName = currentFolder + "at"; % Append "at"

% Save constant.mat file, which consists of the following structures
save(fileName, 'SIS_const','FE_const', 'SM_const', 'ES_const');
disp("Done: Write constants.mat");
%-----------------------------------END-----------------------------------%
