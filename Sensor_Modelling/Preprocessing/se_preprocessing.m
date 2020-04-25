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
HYG = readtable('hygdata_v3.csv');
if (se_debug_run == 1); disp('Preprocessing: Catalogue Successfully Read'); end

% Remove the following columns - 'hip', 'hd', 'hr', 'gl', 'bf', 'proper', 'rv', 'absmag', 'bayer', 'flam', 'con', 'comp', 'comp_primary', 'base', 'var', 'var_min', 'var_max'
HYG = removevars(HYG,{'hip', 'hd', 'hr', 'gl', 'bf', 'proper', 'rv', 'absmag', 'bayer', 'flam', 'con', 'comp', 'comp_primary', 'base', 'var', 'var_min', 'var_max'});
if (se_debug_run == 1); disp('Preprocessing: Catalogue Successfully Trimmed'); end

% Copy the stars with Magnitude less than se_magnitude_limit to
% Simulation_HYG
Simulation_HYG = HYG(HYG.mag <= se_magnitude_limit, :);
if (se_debug_run == 1); disp('Preprocessing: Catalogue Successfully Modified'); end

% Add Columns x0, y0, z0 (Cartesian coordinates) of the stars to the table
% using the RA, Dec, Roll fields (Independent of Boresight Input)
Simulation_HYG.ra_hrs = Simulation_HYG.ra;
Simulation_HYG.ra = (Simulation_HYG.ra) .* 360 / 24;
Simulation_HYG.x0 = + cosd(Simulation_HYG.dec) .* cosd(Simulation_HYG.ra);
Simulation_HYG.y0 = + cosd(Simulation_HYG.dec) .* sind(Simulation_HYG.ra);
Simulation_HYG.z0 = + sind(Simulation_HYG.dec);
% Display Sucess
if (se_debug_run == 1); disp('Preprocessing: Succesfully Converted to Cartesian Coordinates'); end

% Remove sun from the database
Simulation_HYG([1],:) = [];

% Renaming all headers
Simulation_HYG.Properties.VariableNames{'id'} = 'Star_ID';
Simulation_HYG.Properties.VariableNames{'ra'} = 'RA';
Simulation_HYG.Properties.VariableNames{'dec'} = 'Dec';
Simulation_HYG.Properties.VariableNames{'dist'} = 'Distance';
Simulation_HYG.Properties.VariableNames{'pmra'} = 'pm_RA';
Simulation_HYG.Properties.VariableNames{'pmdec'} = 'pm_Dec';
Simulation_HYG.Properties.VariableNames{'mag'} = 'Magnitude';
Simulation_HYG.Properties.VariableNames{'spect'} = 'Spectral_Type';
Simulation_HYG.Properties.VariableNames{'ci'} = 'Color_Index';
Simulation_HYG.Properties.VariableNames{'x'} = 'x';
Simulation_HYG.Properties.VariableNames{'y'} = 'y';
Simulation_HYG.Properties.VariableNames{'z'} = 'z';
Simulation_HYG.Properties.VariableNames{'vx'} = 'v_x';
Simulation_HYG.Properties.VariableNames{'vy'} = 'v_y';
Simulation_HYG.Properties.VariableNames{'vz'} = 'v_z';
Simulation_HYG.Properties.VariableNames{'rarad'} = 'RA_Radians';
Simulation_HYG.Properties.VariableNames{'decrad'} = 'Dec_Radians';
Simulation_HYG.Properties.VariableNames{'pmrarad'} = 'pm_RA_Radians';
Simulation_HYG.Properties.VariableNames{'pmdecrad'} = 'pm_Dec_Radians';
Simulation_HYG.Properties.VariableNames{'lum'} = 'Luminosity';
Simulation_HYG.Properties.VariableNames{'ra_hrs'} = 'RA_hrs';
Simulation_HYG.Properties.VariableNames{'x0'} = 'x0';
Simulation_HYG.Properties.VariableNames{'y0'} = 'y0';
Simulation_HYG.Properties.VariableNames{'z0'} = 'z0';


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


