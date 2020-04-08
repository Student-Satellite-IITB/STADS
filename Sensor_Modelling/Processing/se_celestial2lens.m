% This script rotates all star coordinates from the celestial sphere into
% the boresight coordinates or lens coordinates.

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

% Approach 1: Using 3 Rotations Matrices
% Define Rotation Matrices
Rx = [1 0 0; 0 cosd(se_Dec) -sind(se_Dec); 0 sind(se_Dec) cosd(se_Dec)];
Ry = [cosd(se_RA) 0 sind(se_RA); 0 1 0; -sind(se_RA) 0 cosd(se_RA)];
Rz = [cosd(se_Roll) -sind(se_Roll) 0; sind(se_Roll) cosd(se_Roll) 0; 0 0 1];

% Add a new column containing x1, y1, z1
T.r1 = [T.x1, T.y1, T.z1];
if (se_debug_run == 1); disp('Celestial to Lens: Celestial Coordinates Loaded'); end

% Perform 1st rotation
T.r2 = T.r1 * Ry';
if (se_debug_run == 1); disp('Celestial to Lens: 1st Euler Rotation Sucessful'); end

% Perform 2nd rotation
T.r3 = T.r2 * Rx';
if (se_debug_run == 1); disp('Celestial to Lens: 2nd Euler Rotation Sucessful'); end

% Perform 3rd rotation
T.r4 = T.r3 * Rz';
if (se_debug_run == 1); disp('Celestial to Lens: 3rd Euler Rotation Sucessful'); end

% Approach 2: Using Matlab to generate Rotation Matrix from the Euler
% angles
se_euler_rotation = eul2rotm([-se_RA, -se_Dec, -se_Roll], 'YXZ');

T.r = [T.x1, T.y1, T.z1] .* se_euler_rotation;

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




