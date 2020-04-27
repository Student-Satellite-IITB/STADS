% This script brings the 3D cartesian lens coordinates into 2D cartesian
% sensor coordinates

%% Load Databse
% Load se.mat to get table T
load('se.mat', 'se_T');
load('se_variables.mat', 'se_focal_length');

%% Lens to Sensor
% Converting the unit vectors in the lens frame to 2D cartesian coordinates
% in the sensor frame
% Defining an anonymous function - 
se_func_lens2sensor_y = @(r3) r3(1) * se_focal_length / r3(1);
se_func_lens2sensor_z = @(r3) r3(2) * se_focal_length / r3(1);
se_T = [se_T rowfun(se_func_lens2sensor_y, se_T, 'InputVariables', 'r3', 'OutputVariableName', 'Sensor_y')...
    rowfun(se_func_lens2sensor_z, se_T, 'InputVariables', 'r3', 'OutputVariableName', 'Sensor_z')];
if (se_debug_run == 1); disp('Lens to Sensor: Conversion Successful'); end

%% Save Database
% Save the table T into se.mat
save('./Sensor_Modelling/se.mat', 'se_T');
if (se_debug_run == 1); disp('Lens to Sensor: Database Successfully Saved to se.mat'); end

% Clear functions
if (se_debug_run == 1); clear('se_func_lens2sensor_y', 'se_func_lens2sensor_z'); end

% Display Sucess
fprintf('Lens to Sensor: Success \n \n');