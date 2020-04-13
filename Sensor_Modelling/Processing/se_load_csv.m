% Loads Simulation_HYG.csv into se.mat
%   se.mat contains the table containing all relevant data for Sensor
%   Modelling

% Load level.mat to get file level
load('level.mat', 'level');

% Add to Path - Inputs
if (level == 1)
    addpath(genpath('./Processing/'));
elseif (level == 0)
    addpath(genpath('./Sensor_Modelling/Processing/'));
else
    error('Error: level.mat file missing or incorrect path');
end

% Read Simulation_HYG.csv into table T
T = readtable('Simulation_HYG.csv');

% Save the table T into se.mat
if (level == 1)
    save('./se.mat', 'T');
elseif (level == 0)
    save('./Sensor_Modelling/se.mat', 'T');
else
    error('Error: level.mat file missing or incorrect path');
end

% Display Sucess
disp('Load CSV: Database Successfully Loaded to se.mat');

