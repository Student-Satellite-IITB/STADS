% Trims the Star Catalogue to within FOV and stores them in se.mat
%   ...

%% Load Database
% Load se.mat to get table T
load('se_SKY2000.mat', 'se_T');

%% Trim Database to within the FOV
% Defining an anonymous function - 
se_func_ang_dist = @(r0) rad2deg(atan2(norm(cross(se_r0,r0)), dot(se_r0,r0)));
    
% Add angular ditance wrt boresight
se_T = [se_T rowfun(se_func_ang_dist, se_T, 'InputVariables', 'r0', 'OutputVariableName', 'Angular_Distance')];
if (se_debug_run == 1); disp('Angular Distance: Angular Distance Successfully Added'); end

% Retain stars with Angular Distance less than FOV
se_T = se_T(se_T.Angular_Distance <= se_FOV_circular, :);
if (se_debug_run == 1); disp('Angular Distance: Database Successfully Modified'); end

%% Save Database
% Save the table T into se.mat
save('./Sensor_Modelling/se.mat', 'se_T');
if (se_debug_run == 1); disp('Angular Distance: Database Successfully Loaded to se.mat'); end

% Clear functions
if (se_debug_run == 1); clear('se_func_ang_dist'); end

% Display Sucess
fprintf('Angular Distance: Success \n \n');

