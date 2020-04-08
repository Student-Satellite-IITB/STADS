% Takes all the input data from *.csv in './Inputs' and stores them into
% se_variables.mat.

% Load level.mat to get file level
load('level.mat', 'level');

% Add to Path - Inputs
if (level == 1)
    addpath(genpath('./Inputs/'));
    addpath(genpath('./Functions/'));
elseif (level == 0)
    addpath(genpath('./Sensor_Modelling/Inputs/'));
    addpath(genpath('./Sensor_Modelling/Functions/'));
else
    error('Error: level.mat file missing or incorrect path');
end

% Read Sensor Modelling Inputs
se_inputs = readtable('se_inputs.xls', 'ReadVariableNames', false, 'ReadRowNames', true);
se_inputs = se_inputs(:,1);
% Read Image Generation Inputs
se_ig_inputs = readtable('se_ig_inputs.xls', 'ReadVariableNames', false, 'ReadRowNames', true);
se_ig_inputs = se_ig_inputs(:,1);
% Read Optics Inputs
se_op_inputs = readtable('se_op_inputs.xls', 'ReadVariableNames', false, 'ReadRowNames', true);
se_op_inputs = se_op_inputs(:,1);
% Display - debug - to be removed
% disp(str2double(se_inputs{'Right Ascension', 1}{1}));

% For Debug Run, set debug_run = 1; o/w debug_run = 0;
se_debug_run =      str2double(se_inputs{'Debug', 1}{1});

% For Preprocessing, change the se_magnitude_limit and set se_pp = 1; o/w
% se_pp = 0;
se_magnitude_limit= str2double(se_inputs{'Magnitude Limit', 1}{1});
se_pp =             str2double(se_inputs{'Preprocessing', 1}{1});
% If the se_magnitude_limit has changed, then automatically set se_pp = 1
if (se_check_mag_lim(se_magnitude_limit) == 1)
    se_pp = 1;
end

% Automatically change se_pp back to 0 after 1 run if se_pp == 1
if (se_pp == 1)
    if (level == 1)
        writematrix(0,'./Inputs/se_inputs.xls','Range','B4'); 
    elseif (level == 0)
        writematrix(0,'./Sensor_Modelling/Inputs/se_inputs.xls','Range','B4');
    else
        error('Error: level.mat file missing or incorrect path');
    end
end
% Display Success
if (se_debug_run == 1); disp('Edit Input Data: Preprocessing Variables Read Successfully'); end


% Boresight Input - RA (hours), Dec (Degrees), Roll:
se_RA_hr =          str2double(se_inputs{'Right Ascension', 1}{1});
se_Dec =            str2double(se_inputs{'Declination', 1}{1});
se_Roll =           str2double(se_inputs{'Roll', 1}{1});
% RA (Degrees) Calculation:
se_RA = se_RA_hr * 15;  % Degrees; 15 = 360 / 24    % DO NOT EDIT
if (se_debug_run == 1); disp('Edit Input Data: Boresight Input Read Successfully'); end

% Optics Inputs:
se_FOV_length =     str2double(se_op_inputs{'FOV Length', 1}{1});
se_FOV_width =      str2double(se_op_inputs{'FOV Width', 1}{1});
se_CMOS_length =    str2double(se_op_inputs{'CMOS Length', 1}{1});
se_CMOS_width =     str2double(se_op_inputs{'CMOS Width', 1}{1});
se_focal_length =   str2double(se_op_inputs{'Focal Length', 1}{1});
se_pixel_size =     str2double(se_op_inputs{'Pixel Size', 1}{1});
% Calculations:
% Diametrical FOV, in Degrees
se_FOV_circular =   sqrt(se_FOV_length^2 + se_FOV_width^2);   
if (se_debug_run == 1); disp('Edit Input Data: Optics Inputs Read Successfully'); end

% Image Generation Inputs:
se_sigma =          str2double(se_ig_inputs{'Sigma', 1}{1});
se_check_radius =   str2double(se_ig_inputs{'Check Radius', 1}{1});
if (se_debug_run == 1); disp('Edit Input Data: Image Generation Inputs Read Successfully'); end

% Save all relevant workspace variables to 'se_variables.mat'
if (level == 1)
    save('./se_variables.mat', 'se_debug_run', 'se_magnitude_limit', 'se_pp', 'se_RA', 'se_Dec', 'se_Roll', 'se_FOV_circular', 'se_CMOS_length', 'se_CMOS_width', 'se_focal_length', 'se_pixel_size', 'se_sigma', 'se_check_radius');
elseif (level == 0)
    save('./Sensor_Modelling/se_variables.mat', 'se_debug_run', 'se_magnitude_limit', 'se_pp', 'se_RA', 'se_Dec', 'se_Roll', 'se_FOV_circular', 'se_CMOS_length', 'se_CMOS_width', 'se_focal_length', 'se_pixel_size', 'se_sigma', 'se_check_radius');
else
    error('Error: level.mat file missing or incorrect path');
end

% Display Success
disp('Edit Input Data: Input Data Saved Successfully');