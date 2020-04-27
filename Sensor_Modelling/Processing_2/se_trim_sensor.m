% Trims the Star Catalogue to within the sensor frame and stores them in se.mat
%   ...

%% Load Database
% Load se.mat to get table T
load('se.mat', 'se_T');

%% Trim Database to within the sensor frame% Defining an anonymous function - 
% Retain stars within the sensor frame
se_T = se_T(se_T.Sensor_y <= se_CMOS_width / 2, :);
se_T = se_T(se_T.Sensor_y >= - se_CMOS_width / 2, :);
se_T = se_T(se_T.Sensor_z <= se_CMOS_length / 2, :);
se_T = se_T(se_T.Sensor_z >= - se_CMOS_length / 2, :);
if (se_debug_run == 1); disp('Trim to Sensor: Database Successfully Modified'); end

%% Save Database
% Save the table T into se.mat
save('./Sensor_Modelling/se.mat', 'se_T');
if (se_debug_run == 1); disp('Trim to Sensor: Database Successfully Loaded to se.mat'); end

% Display Sucess
fprintf('Trim to Sensor: Success \n \n');

