% This script rotates all star coordinates from the celestial sphere into
% the boresight coordinates or lens coordinates.

%% Load Database
% Load se.mat to get table T
load('se.mat', 'se_T');

%% Approach 1: ICRS to Lens - Without Robotics Toolbox
% Approach 1: Using 3 Rotations Matrices
% Define Rotation Matrices
se_Rx = [1 0 0; 0 cosd(se_Roll) -sind(se_Roll); 0 sind(se_Roll) cosd(se_Roll)];
se_Ry = [cosd(se_Dec) 0 sind(se_Dec); 0 1 0; -sind(se_Dec) 0 cosd(se_Dec)];
se_Rz = [cosd(se_RA) -sind(se_RA) 0; sind(se_RA) cosd(se_RA) 0; 0 0 1];

% Add a new column containing [x0, y0, z0]
% se_T.r0 = [se_T.x0, se_T.y0, se_T.z0];

% Perform 1st rotation
se_T.r1 = se_T.r0 * se_Rz;
if (se_debug_run == 1); disp('Celestial to Lens: 1st Euler Rotation Sucessful'); end

% Perform 2nd rotation
se_T.r2 = se_T.r1 * se_Ry';
if (se_debug_run == 1); disp('Celestial to Lens: 2nd Euler Rotation Sucessful'); end

% Perform 3rd rotation
se_T.r3 = se_T.r2 * se_Rx';
if (se_debug_run == 1); disp('Celestial to Lens: 3rd Euler Rotation Sucessful'); end

%% Approach 2: ICRS to Lens - With Robotics Toolbox
% Approach 2: Using Matlab to generate Rotation Matrix from the Euler
% angles
% se_euler_rotation = eul2rotm([deg2rad(se_RA), deg2rad(-se_Dec), deg2rad(-se_Roll)], 'ZYX');
se_euler_rotation = angle2dcm(deg2rad(se_RA), deg2rad(-se_Dec), deg2rad(-se_Roll), 'ZYX')';
se_T.r = se_T.r0 * se_euler_rotation;

%% Save Database
% Save the table T into se.mat
save('./Sensor_Modelling/se.mat', 'se_T');
if (se_debug_run == 1); disp('Celestial to Lens: Database Successfully Saved to se.mat'); end
    
% Display Sucess
fprintf('Celestial to Lens: Success \n \n');