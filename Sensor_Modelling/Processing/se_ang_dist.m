% Trims the Star Catalogue to within FOV and stores them in se.mat
%   ...

% Load level.mat to get file level
load('level.mat', 'level');

% Add to Path - Inputs
if (level == 1)
    addpath(genpath('./Functions/'));
elseif (level == 0)
    addpath(genpath('./Sensor_Modelling/Functions/'));
else
    error('Error: level.mat file missing or incorrect path');
end

% Load se.mat to get table T
load('se.mat', 'T');

% Defining an anonymous function - 
ang_dist = @(r0) rad2deg(atan2(norm(cross(se_r0,r0)), dot(se_r0,r0)));

% Add angular ditance wrt boresight
T = [T rowfun(ang_dist, T, 'InputVariables', 'r0', 'OutputVariableName', 'Angular_Distance')];
if (se_debug_run == 1); disp('Angular Distance: Angular Distance Successfully Added'); end

% Copy the stars with Magnitude less than se_magnitude_limit to
% Simulation_HYG
T = T(T.Angular_Distance <= se_FOV_circular, :);
if (se_debug_run == 1); disp('Angular Distance: Catalogue Successfully Modified'); end

% Save the table T into se.mat
if (level == 1)
    save('./se.mat', 'T');
elseif (level == 0)
    save('./Sensor_Modelling/se.mat', 'T');
else
    error('Error: level.mat file missing or incorrect path');
end

% Display Sucess
disp('Angular Distance: Database Successfully Loaded to se.mat');

