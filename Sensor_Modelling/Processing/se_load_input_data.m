% Takes all the input data from *.csv in './Inputs' and stores them into
% se_variables.mat.

%% Read Inputs
% Read Sensor Modelling Inputs
se_inputs = readmatrix('se_inputs.xlsx','Range','B2:B10');
% Read Image Generation Inputs
se_ig_inputs = readmatrix('se_ig_inputs.xlsx','Range','B2:B10');
% Read Optics Inputs
se_op_inputs = readmatrix('se_op_inputs.xlsx','Range','B2:B10');

%% Define Variable from Inputs
% For Debug Run, set debug_run = 1; o/w debug_run = 0;
se_debug_run =      se_inputs(1);

% For Preprocessing, change the se_magnitude_limit and set se_pp = 1; o/w
% se_pp = 0;
se_magnitude_limit= se_inputs(2);
se_pp =             se_inputs(3);
% If the se_magnitude_limit has changed, then automatically set se_pp = 1
if (se_check_mag_lim(se_magnitude_limit) == 1)
    se_pp = 1;
end

% Automatically change se_pp back to 0 after 1 run if se_pp == 1
if (se_pp == 1)
    writematrix(0,'./Sensor_Modelling/Inputs/se_inputs.xlsx','Range','B4');
end
% Display Success
if (se_debug_run == 1); disp('Edit Input Data: Preprocessing Variables Read Successfully'); end

% Boresight Input - RA (Degrees), Dec (Degrees), Roll:
se_RA =             se_inputs(4);
se_Dec =            se_inputs(5);
se_Roll =           se_inputs(6);
if (se_debug_run == 1); disp('Edit Input Data: Boresight Input Read Successfully'); end

% Optics Inputs:
% se_FOV_length =     se_op_inputs(1);
% se_FOV_width =      se_op_inputs(2);
se_CMOS_length =    se_op_inputs(3);
se_CMOS_width =     se_op_inputs(4);
se_focal_length =   se_op_inputs(5);
se_pixel_size =     se_op_inputs(6);
% Calculations:
% Diametrical FOV, in Degrees
se_FOV_circular =   sqrt(se_op_inputs(1) ^ 2 + se_op_inputs(2) ^ 2);   
% se_FOV_circular =   sqrt(se_FOV_length^2 + se_FOV_width^2);   
if (se_debug_run == 1); disp('Edit Input Data: Optics Inputs Read Successfully'); end

% Image Generation Inputs:
se_sigma =          se_ig_inputs(1);
se_check_radius =   se_ig_inputs(2);
if (se_debug_run == 1); disp('Edit Input Data: Image Generation Inputs Read Successfully'); end

% se_r0 - Boresight Axis in Cartesian Coordinates
se_r0 = [cosd(se_Dec) .* cosd(se_RA),...
         cosd(se_Dec) .* sind(se_RA),...
         sind(se_Dec)];
     
% Clear se_inputs, se_ig_inputs, se_op_inputs
if (se_debug_run == 1); clear('se_inputs', 'se_ig_inputs', 'se_op_inputs'); end

%% Save Variables
% Save all relevant workspace variables to 'se_variables.mat'
save('./Sensor_Modelling/se_variables.mat', 'se_debug_run', 'se_magnitude_limit', 'se_pp', 'se_RA', 'se_Dec', 'se_Roll', 'se_FOV_circular', 'se_CMOS_length', 'se_CMOS_width', 'se_focal_length', 'se_pixel_size', 'se_sigma', 'se_check_radius');
if (se_debug_run == 1); disp('Edit Input Data: Input Data Saved Successfully'); end

% Display Success
fprintf('Edit Input Data: Success \n \n');

