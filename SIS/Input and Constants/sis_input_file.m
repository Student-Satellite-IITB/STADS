
% This file loads all the constants and inputs from *.xlsx files in the Input and Constants folder
% The inputs and constants are stored in the structure sis_input

%% -----------------------------------------
% Part 1 - Loading the General Inputs:
% -----------------------------------------

sis_general_mat = readmatrix('sis_in_general.xlsx','Range','B2:B5');
sis_input.gen.Debug_Run =              sis_general_mat(1); % Debug Run or Silent Run
sis_input.gen.Magnitude_Limit =        sis_general_mat(2); % Sensor Model Star Magnitude Limit
sis_input.gen.N_bo =                   sis_general_mat(3); % Number of Boresight and angular velocity inputs in sis_in_bo.xlsx
sis_input.gen.N_sub_im =               sis_general_mat(4); % Number of sub images for each image
sis_input.gen.sim_N =                  sis_general_mat(5); % The simulation Number
if (sis_input.gen.Debug_Run == 1); disp('Preprocessing: General Inputs Read'); end

%% -------------------------------------------------------------
% Part 2 - Loading the Boresight and Angular Velocity Inputs:
% -------------------------------------------------------------

sis_bo_mat = readmatrix('se_in_bo.xlsx','Range', strcat('B2:G', num2str(sis_input.gen.N_bo + 1)));
sis_input.bo = array2table(sis_bo_mat, "VariableNames", ["RA", "Dec", "Roll", "Ang_1", "Ang_2", "Ang_3"]);
sis_input.bo.sis_r0 = [cosd(sis_input.bo.Dec) .* cosd(sis_input.bo.RA), cosd(sis_input.bo.Dec) .* sind(sis_input.bo.RA), sind(sis_input.bo.Dec)];
if (sis_input.gen.Debug_Run == 1); disp('Preprocessing: Boresight and Angular Velocity Inputs Read'); end


%% -------------------------------------------------------------
% Part 3 - Loading Constants for Lens, Light and Sensor Model:
% -------------------------------------------------------------

sis_lls_mat = readmatrix('sis_in_lls.xlsx','Range','B2:B15');
sis_input.lls.CMOS.Length_Pix =   sis_lls_mat(1);        % Pixels
sis_input.lls.CMOS.Width_Pix =    sis_lls_mat(2);        % Pixels
sis_input.lls.CMOS.Pixel_Size =   sis_lls_mat(4) * 1e-3; % mm -> m
sis_input.lls.CMOS.Defocus =      sis_lls_mat(6) * 1e-3; % mm -> m
sis_input.lls.Lens.Focal_Length = sis_lls_mat(3) * 1e-3; % mm -> m
sis_input.lls.Lens.Diameter =     sis_lls_mat(5) * 1e-3; % mm -> m

sis_input.lls.Pixel_Spread =    sis_lls_mat(8);        % Pixels
sis_input.lls.Capture_Rate =    sis_lls_mat(9);        % Hz
sis_input.lls.Eta =             sis_lls_mat(10) / 100;  % In Decimals
sis_input.lls.Gain =            sis_lls_mat(11);        % In LSB10 / electron
sis_input.lls.Exposure_Time =   sis_lls_mat(12);        % Seconds
sis_input.lls.MTF =             sis_lls_mat(13) / 100;  % In Decimals
sis_input.lls.Full_Well =       sis_lls_mat(14);        % Electrons - May be used later
sis_input.lls.Lens_Eff =        sis_lls_mat(15) / 100;  % In Decimals


sis_input.lls.CMOS.Length =     sis_input.lls.CMOS.Length_Pix * sis_input.lls.CMOS.Pixel_Size;      % m
sis_input.lls.CMOS.Width =      sis_input.lls.CMOS.Width_Pix * sis_input.lls.CMOS.Pixel_Size;       % m
sis_input.lls.CMOS.Diagonal =   sqrt(sis_input.lls.CMOS.Length ^ 2 + sis_input.lls.CMOS.Width ^ 2); % m

sis_input.lls.FOV.Length =      2 * atand(sis_input.lls.CMOS.Length / (2 * sis_input.lls.Lens.Focal_Length));   % Degrees
sis_input.lls.FOV.Width =       2 * atand(sis_input.lls.CMOS.Width / (2 * sis_input.lls.Lens.Focal_Length));    % Degrees
sis_input.lls.FOV.Circular =    2 * atand(sis_input.lls.CMOS.Diagonal / (2 * sis_input.lls.Lens.Focal_Length)); % Degrees


sis_input.lls.Gauss_Sigma =   (sis_input.lls.Pixel_Spread * sqrt(2)) / 3; 

sis_input.lls.C_1 = 3640 * 1.51e7 * 0.16 * (sis_input.lls.Exposure_Time/sis_input.gen.N_sub_im) * (pi * sis_input.lls.Lens.Diameter ^ 2 / 4) * sis_input.lls.MTF * sis_input.lls.Lens_Eff;
sis_input.lls.C_2 = 100 ^ 0.2;

%Calculating Backgrounf Noise
% code
sis_input.lls.BN = 0;
if (sis_input.gen.Debug_Run == 1); disp('Preprocessing: Lens, Light and Sensor Inputs Read'); end


%% -------------------------------------------------------------
% Part 3 - Loading Noice Model Inputs:
% -------------------------------------------------------------
sis_noice_mat = readmatrix('sis_in_noise.xlsx','Range', 'B2:B15');
sis_input.noise.DTN =         sis_noice_mat(1);        % # Electrons
sis_input.noise.FPN =         sis_noice_mat(2);        % LSB10
sis_input.noise.PLS =         sis_noice_mat(3);        % No Units
sis_input.noise.PRNU =        sis_noice_mat(4) / 100;  % Percentage -> Decimal
sis_input.noise.PSNL =        sis_noice_mat(5);        % LSB10
sis_input.noise.DS =          sis_noice_mat(6);        % # Electrons / s
sis_input.noise.SNR =         sis_noice_mat(7);        % dB
sis_input.noise.DR =          sis_noice_mat(8);        % dB
sis_input.noise.rng_Seed =    sis_noice_mat(9);        % NA
sis_input.noise.Read_Rate =   sis_noice_mat(10) * 1e6; % Mbps -> bps
if (sis_input.gen.Debug_Run == 1); disp('Preprocessing: Noise Inputs Read'); end


%% Save the Inputs to a mat file
% This section saves all the concerned structures SIS/Input and
% Constants/sis_input.mat
save('./SIS/Input and Constants', "sis_input");
clearvars("sis_bo_mat","sis_general_mat", "se_inputs_mat", "sis_lls_mat", "sis_noice_mat");
if (sis_input.gen.Debug_Run == 1); disp('Preprocessing: Inputs Saved'); end
fprintf('\n');


clear
