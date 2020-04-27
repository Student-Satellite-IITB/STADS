% Main Function for Sensor Modelling Block
%   The Sensor Model Generates the Image as seen by the Star Tracker in
%   space. This is input to the Feature Extraction Block.
    
%% Load Input Data
se_load_input_data;

%% Load Variables
load('se_variables.mat', 'se_pp', 'se_debug_run');

% Temporary - to be removed after  debugging
if (se_debug_run == 1); se_pp = 1; end

%% Preprocess the SKY 2000 Catalogue
if (se_pp == 1)
    se_preprocessing; 
elseif (se_pp == 0)
    disp('Preprocessing: Skipped');
end

%% Trim the database to within FOV
se_ang_dist;

%% ICRS to Lens Frame
se_icrs2lens;

%% Lens Frame to Sensor Frame
se_lens2sensor;

%% Trim to Sensor Frame
se_trim_sensor;

% Display Success Message;
fprintf('Sensor Modelling Main: Success \n \n');