% This preprocesses the HYG Database as per the requirements
%   This function loads se_magnitude_limit from se_Variables.mat in the
%   Parent Directory. Then, only StarID, RA, Dec, Mag, and Distance columns
%   are reatined. Finally, only stars with Magnitude value less than
%   se_magnitude_limit are retained. The final Pre-procesed catalogue is
%   saved in the parent directory under the name Simulation_HYG.csv

% Load level.mat to get file level
load('level.mat', 'level');

% Add to Path - Preprocessing
if (level == 1)
    addpath(genpath('./Preprocessing/'));
elseif (level == 0)
    addpath(genpath('./Sensor_Modelling/Preprocessing/'));
else
    error('Error: level.mat file missing or incorrect path');
end

% Load 'se_magnitude_limit' and 'ae_debug_run' from 'se_variables.mat'
load('se_variables.mat', 'se_magnitude_limit', 'se_debug_run');

% Read the HYG Catalogue - HYG.csv into the table HYG
HYG = readtable('HYG.csv');
if (se_debug_run == 1); disp('Preprocessing: Catalogue Successfully Read'); end

% Remove the following columns - 'Hip', 'HD', 'HR', 'Gliese', 'BayerFlamsteed', 'ProperName', 'AbsMag', 'Spectrum', 'ColorIndex'
HYG = removevars(HYG,{'Hip', 'HD', 'HR', 'Gliese', 'BayerFlamsteed', 'ProperName', 'AbsMag', 'Spectrum', 'ColorIndex'});
if (se_debug_run == 1); disp('Preprocessing: Catalogue Successfully Trimmed'); end

% Copy the stars with Magnitude less than se_magnitude_limit to
% Simulation_HYG
Simulation_HYG = HYG(HYG.Mag <= se_magnitude_limit, :);
if (se_debug_run == 1); disp('Preprocessing: Catalogue Successfully Modified'); end

% Store the Simulation_HYG table into '../Simulation_HYG.csv'
if (level == 1)
    writetable(Simulation_HYG, './Processing/Simulation_HYG.csv');
elseif (level == 0)
    writetable(Simulation_HYG, './Sensor_Modelling/Processing/Simulation_HYG.csv');
else
    error('Error: level.mat file missing or incorrect path');
end

% Display Sucess
if (se_debug_run == 1); disp('Preprocessing: Modified Catalogue Successfully Saved'); end


