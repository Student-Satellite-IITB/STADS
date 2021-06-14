%% *IIT Bomaby, Student Satellite Program*
%% *Star Tracker-based Attitude Determination System (STADS)*
%% *Model-in-Loop Simulation Framework*
%% *Version - 1.0*

 
clear
clc
%% *Simuation Details*

% Manual Entry
sim_log.operator = "Pranjal Gupta"; % Enter Simulation Operator's Full Name
sim_log.operator_ID = "PG"; % Enter Operator ID
sim_log.sim_ID = "11"; % Enter Simulation Number
sim_log.path = "/Users/pranjalgupta/Documents/Satlab/STADS/OLS/MILS/Simulation_3"; % Enter Path of Simulation Folder
sim_log.SIS_path = "/Users/pranjalgupta/Documents/Satlab/STADS/OLS/SIS/SIS_run1"; % Enter Path of the SIS Folder
% Automated Entry
sim_log = sim_log_additional_details(sim_log);

%% Copying the Star Image Simulation Data
% checking if the SIS data is stored in the SIS folder
if ~isfile(fullfile(sim_log.SIS_path,"SIS_log.md"))
    error("SimulationError: SIS_log.md does not exist in the SIS Folder")
else
    source = fullfile(sim_log.SIS_path,"SIS_log.md");
    destination = fullfile(sim_log.path,"SIS_log.md");
    copyfile(source,destination);
end

if ~isfolder(fullfile(sim_log.SIS_path,"Output"))
    error("SimulationError: Output does not exist in the SIS Folder")
else
    source = fullfile(sim_log.SIS_path,"Output");
    destination = fullfile(sim_log.path,"Output");
    copyfile(source,destination);
end

if ~isfolder(fullfile(sim_log.SIS_path,"Preprocessing"))
    error("SimulationError: Preprocessing does not exist in the SIS Folder")
else
    source = fullfile(sim_log.SIS_path,"Preprocessing");
    destination = fullfile(sim_log.path,"Preprocessing");
    copyfile(source,destination);
end


source = fullfile(sim_log.SIS_path,"error_vars.mat");
destination = fullfile(sim_log.path,"error_vars.mat");
copyfile(source,destination);

source = fullfile(sim_log.SIS_path,"inputs.csv");
destination = fullfile(sim_log.path,"inputs.csv");
copyfile(source,destination);

source = fullfile(sim_log.SIS_path,"simulation_constants.m");
destination = fullfile(sim_log.path,"simulation_constants.m");
copyfile(source,destination);

source = fullfile(sim_log.SIS_path,"simulation_constants.mat");
destination = fullfile(sim_log.path,"simulation_constants.mat");
copyfile(source,destination);

disp("Done: Copying SIS files");
%% Model-In-Loop Simulation (MILS)
% Model
%% 
% # Lost-in-Space Redundancy is valid only if Tracking Mode is Enabled!

if ~exist('sim_log', 'var')
    error("SimulationError: Simulation Details Not Loaded! Re-load the details!")
end
sim_log.MILS.fe_data.algo = "Region Growth"; % Feature Extraction algorithm
sim_log.MILS.sm_data.preprocessing = true; % Enable pre-processing of SIS
sim_log.MILS.sm_data.LIS_algo = "4-Star Matching"; % Star-Matching (Lost-in-Space Mode) algorithm 
sim_log.MILS.sm_data.TM_algo =  "NONE"; % Star-Matching (Tracking Mode) algorithm 
sim_log.MILS.sm_data.LIS_redundancy = false; % Star-Matching (Lost-in-Space redundancy)
sim_log.MILS.es_data.algo = "QUEST2"; % Estimation algorithm

 
% Load Inputs & Constants

% Add Simulation Path
addpath(genpath(sim_log.path));

% Output filename for LIS preprocessed data
sim_log.MILS.PP_LIS_outputFileName = fullfile(sim_log.PP_output_path, "LIS_preprocessed_data.mat");

% Output filename for TM preprocessed data
sim_log.MILS.PP_TM_outputFileName = fullfile(sim_log.PP_output_path, "TM_preprocessed_data.mat");

%% Load Inputs & Constants File

sim_check_required_files(sim_log, "MILS"); % Checks whether required files are there in the directory

% Load constants.mat, and SIS_log.mat file.
load( fullfile(sim_log.path, "simulation_constants.mat") );
load( fullfile(sim_log.output_path, "SIS_log.mat") );

% Total number of iterations to be performed in the simulation
sim_log.N_Iter = SIS_log.N_Iter;

disp("Done: Load Inputs & Simulation Constants");
% Generate Model-in-Loop Simulation - Log file    

%%% Read MILS-data files

%% Feature Extraction Data
if sim_log.MILS.fe_data.algo == "Default Block"
    %%%%%% Load Default Block data
elseif sim_log.MILS.fe_data.algo == "Region Growth"
    %%%%%% Load RG Block data
elseif sim_log.MILS.fe_data.algo == "Line-by-Line"
    %%%%%% Load LBL Block data
end

%% Create MILS_log.md file

MILS_logFile = fopen(fullfile(sim_log.path, "MILS_log.md"),'w');
sim_log_file_header(sim_log, MILS_logFile, "MILS"); % Write header for log file
try
    
% Run Star-Matching - Preprocessing   
    sim_log = sm_PP_main(sim_log,SM_const,MILS_logFile);
    
    % Load Star-Matching - Preprocessed Data
    load(sim_log.MILS.PP_LIS_outputFileName, 'sm_PP_LIS_output');
    load(sim_log.MILS.PP_TM_outputFileName, 'sm_PP_TM_output');
    
    disp("Done: Star-Matching - Preprocessing");
    
    % Simulation Details
    fprintf(MILS_logFile,'### Simulation - Details\n\n');
    fprintf(MILS_logFile,'|Iter|FE-Status|SM-Status|SM-Mode|SM-Iter|ES-Status|Time_Taken - (mm:ss.SS)|\n');
    fprintf(MILS_logFile, '|:---:|:---:|:---:|:---:|:---:|:---:|:---:|\n');
% *Run Model-in-Loop Simulation*

    ProgBar = waitbar(0,'Starting simulation...'); % Progress-bar GUI
    sim_log = MILS_main(sim_log,ES_const,FE_const,SM_const,ProgBar, MILS_logFile);

    % Clear redundant variables
    clear

catch ME %MException struct    
    
    % Close ProgBar only if it has opened
    if exist('ProgBar','var')  
        close(ProgBar); % Progress-bar GUI    
    end

    % Close the log file after logging the error
    sim_close_log_file(ME, sim_log, MILS_logFile, "MILS"); 
end
