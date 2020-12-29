%% *IIT Bomaby, Student Satellite Program*
%% *Star Tracker-based Attitude Determination System (STADS)*
%% *Model-in-Loop Simulation Framework*
%% *Version - 1.0*

 
clear
clc
%% *Simuation Details*

% Manual Entry
sim_log.operator = "Shashank Singh"; % Enter Simulation Operator's Full Name
sim_log.operator_ID = "SS"; % Enter Operator ID
sim_log.sim_ID = "10"; % Enter Simulation Number
sim_log.path = "C:\Users\Shashank\Documents\GitHub\STADS\MILS\Simulation_2"; % Enter Path of Simulation Folder
sim_log.SIS_path = "C:\Users\Shashank\Documents\GitHub\STADS\MILS\SIS\SIS_run1"; % Enter Path of the SIS Folder
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

    if sim_log.MILS.sm_data.preprocessing == 0
        fprintf(MILS_logFile,'### Preprocessing - Details\n\n');
        fprintf(MILS_logFile, "* Lost-in-Space Mode - Preprocessing: Skipped\n");
        fprintf(MILS_logFile, "* Tracking Mode - Preprocessing: Skipped\n\n");
        
        disp("Star Image Simulation - Preprocessing - Skipped!")
    
    elseif sim_log.MILS.sm_data.preprocessing == 1
        ProgBar = waitbar(0,'Starting preprocessing...'); % Progress-bar GUI
        tic
        fprintf(MILS_logFile,'### Preprocessing - Details\n\n');
        fprintf(MILS_logFile,'|Mode|Status|Time_Taken - (mm:ss.SS)|\n');
        fprintf(MILS_logFile, '|:---:|:---:|:---:|\n');
        
        %%% Run Lost-in-Space Mode Preprocessing
        waitbar(0.2, ProgBar, 'Running LIS preprocessing...'); % Progress-bar GUI
        sim_log.PP_LIS_T1 = datetime(); % Time at which preprocessing starts
        
        sm_PP_LIS_output = sm_PP_LIS_main(SM_const, sim_log);
        
        sim_log.PP_LIS_dt = duration(datetime() - sim_log.PP_LIS_T1, "Format","mm:ss.SS"); % Time taken to excute SIS Preprocessing
        
        % Save the output file
        waitbar(0.4, ProgBar, 'Saving LIS preprocessing...'); % Progress-bar GUI
        save(sim_log.MILS.PP_LIS_outputFileName, 'sm_PP_LIS_output', 'sim_log'); % Save .mat file     
        
        % Write log-entry
        fprintf(MILS_logFile,'|LIS|Done|%s|\n', sim_log.PP_LIS_dt);
        
        
        
        %%% Run Tracking Mode Preprocessing
        waitbar(0.6, ProgBar, 'Running TM preprocessing...'); % Progress-bar GUI
        sim_log.PP_TM_T1 = datetime(); % Time at which preprocessing starts
        
        %sm_PP_TM_output = sm_PP_TM_main();
        %-------Dummy Variables-------%
        sm_PP_TM_output.test1 = 10;
        sm_PP_TM_output.test2 = -10;
        sm_PP_TM_output.status = "Done";
        %-----------------------------%
        
        sim_log.PP_TM_dt = duration(datetime() - sim_log.PP_TM_T1, "Format","mm:ss.SS"); % Time taken to excute SIS Preprocessing
        
        % Save the output file
        waitbar(0.8, ProgBar, 'Saving TM preprocessing...'); % Progress-bar GUI
        save(sim_log.MILS.PP_TM_outputFileName, 'sm_PP_TM_output', 'sim_log'); % Save .mat file     
        
        % Write log-entry
        fprintf(MILS_logFile,'|TM|Done|%s|\n\n', sim_log.PP_TM_dt);
        toc
        close(ProgBar);
    end
    
    % Load Star-Matching - Preprocessed Data
    load(sim_log.MILS.PP_LIS_outputFileName, 'sm_PP_LIS_output');
    load(sim_log.MILS.PP_TM_outputFileName, 'sm_PP_TM_output');
    
    disp("Done: Star-Matching - Preprocessing");
    
    % Simulation Details
    fprintf(MILS_logFile,'### Simulation - Details\n\n');
    fprintf(MILS_logFile,'|Iter|FE-Status|SM-Status|SM-Mode|SM-Iter|ES-Status|Time_Taken - (mm:ss.SS)|\n');
    fprintf(MILS_logFile, '|:---:|:---:|:---:|:---:|:---:|:---:|:---:|\n');
% *Run Model-in-Loop Simulation*

    tic
    sim_log.T1 = datetime(); % Time at which simulation starts
    disp('Start: Model-in-Loop Simulation');
    ProgBar = waitbar(0,'Starting simulation...'); % Progress-bar GUI
    
    iter_info.sm_iter = 0; % Star-Matching Iteration Number
    
    %% Start Iterations
    for i = 1:sim_log.N_Iter
        iter_info.i = i; % Store iteration number
        waitbar(i/sim_log.N_Iter, ProgBar, 'Running simulation...'); % Progress-bar GUI
        
        iter_info.t1 = datetime(); % Time at which iteration starts
        
        %% Read Input   
        
        % Input filename from which the input data for the current iteration is
        % extracted from
        iter_info.inputFileName = fullfile(sim_log.output_path, "SIS_iter_" + string(iter_info.i) + ".mat");
        
        % Output filename in which the output data of the current iteration is
        % stored
        iter_info.outputFileName = fullfile(sim_log.output_path, "MILS_iter_" + string(iter_info.i) + ".mat");
        
        % Load the input file
        load(iter_info.inputFileName, 'sis_output');
        
        fprintf(MILS_logFile,'|%d|', round(iter_info.i)); % Write log file entry  
        
        %% Run Model-in-Loop Simulation on single input
        
        %% Run Feature Extraction Block
        [fe_output, SM_const] = fe_main(sis_output, FE_const, SM_const, sim_log.MILS.fe_data.algo); % Execute FE
        
        % Write log file & Feature Extraction output
        iter_info.fe_status = fe_output.status; % Store iteration status
        save(iter_info.outputFileName, "fe_output", "iter_info"); % Save FE output to .mat file   
        fprintf(MILS_logFile,'%s|', iter_info.fe_status); % Write log file entry - FE    
        
        
        %% Run Star-Matching Block
        if sim_log.MILS.sm_data.TM_algo == "NONE" || iter_info.sm_iter <= 1
            sm_output = sm_LIS_main(sis_output, fe_output, SM_const, sm_PP_LIS_output, sim_log.MILS.sm_data.LIS_algo); %Execute SM (LIS)
                    
            % Store iteration details
            iter_info.sm_mode = "LIS"; % Store operational mode
            iter_info.sm_status = sm_output.status; % Store iteration status
            
            % Increment/Reset sm_iter
            if iter_info.sm_status == "Done"
                iter_info.sm_iter = iter_info.sm_iter + 1; % Increment sm_iter
            elseif iter_info.sm_status == "Fail!"
                iter_info.sm_iter = 0; % Reset sm_iter
            end
        
        elseif iter_info.sm_iter >= 2
            %sm_output = sm_TM_main(fe_output, SM_const, sim_log.MILS.sm_data.TM_algo); %Execute SM (TM)
            %-------Dummy Variables-------%
            sm_output.test1 = [1,2,3,4,5];
            sm_output.test2 = [-10,-20,-30,-40,-50];   
            sm_output.status = "Done";
            %-----------------------------%
            
            % Store iteration details
            iter_info.sm_mode = "TM"; % Store operational mode
            iter_info.sm_status = sm_output.status; % Store iteration status
            
            % Check if Tracking Mode has failed
            if iter_info.sm_status == "Done"
                iter_info.sm_iter = iter_info.sm_iter + 1; % Increment sm_iter
            
            elseif iter_info.sm_status == "Fail!"
                iter_info.sm_iter = 0; % Reset sm_iter
                
                %% Run Lost-in-Space Redundancy
                if sim_log.MILS.sm_data.LIS_redundancy  
                    sm_output = sm_LIS_main(sis_output, fe_output, SM_const, sim_log.MILS.sm_data.LIS_algo); %Execute SM (LIS)
                    
                    % Store iteration details
                    iter_info.sm_mode = "LIS(R!)"; % Store operational mode
                    iter_info.sm_status = sm_output.status; % Store iteration status
                    
                    % Increment/Reset sm_iter
                    if iter_info.sm_status == "Done"
                        iter_info.sm_iter = iter_info.sm_iter + 1;  % Increment sm_iter
                    elseif iter_info.sm_status == "Fail!"
                        iter_info.sm_iter = 0; % Reset sm_iter
                    end
                end
            
            end
        end
     
        
        % Write log file & Star-Matching output    
        save(iter_info.outputFileName, "sm_output", "iter_info", "-append"); % Append SM output to .mat file   
        fprintf(MILS_logFile,'%s|%s|%d|', iter_info.sm_status, iter_info.sm_mode, round(iter_info.sm_iter)); % Write log file entry - SM
        
        
        %% Run Estimation Block
        
        % Run Estimation only if Star-Matching has passed
        if iter_info.sm_status == "Done"
            es_output = es_main(sis_output, sm_output, ES_const, sim_log.MILS.es_data.algo);  %Execute ES           
            iter_info.es_status = es_output.status; % Store iteration status
        else
            iter_info.es_status = "Fail!"; % Store iteration status
            es_output = 0; % Create dummy variable
        end
            
        % Write log file & Estimation output        
        save(iter_info.outputFileName, "es_output", "iter_info", "-append"); % Append ES output to .mat file   
        fprintf(MILS_logFile,'%s|', iter_info.es_status); % Write log file entry - ES
        
        
        % Time taken to excute current iteration
        iter_info.dt = duration(datetime() - iter_info.t1, "Format","mm:ss.SS");
        
        % Save the output file
        save(iter_info.outputFileName, "iter_info", "-append"); % Append iter_info output to .mat file   
        
        % Write log-entry
        fprintf(MILS_logFile,'%s\n', iter_info.dt); % Write log file entry

    end
    
        
    close(ProgBar); % Progress-bar GUI
    disp('Done: Model-in-Loop Simulation');
    sim_log.dt = duration(datetime() - sim_log.T1, "Format","mm:ss.SS"); % Time taken to excute entire MILS simulation

    % Write log-entry
    fprintf(MILS_logFile, '\n---\n');
    if sim_log.MILS.sm_data.preprocessing == 1
        sim_log.dt = sim_log.dt + sim_log.PP_LIS_dt + sim_log.PP_TM_dt;
    end
    fprintf(MILS_logFile,'\n**Total Time Taken:** %s\n', sim_log.dt);
    
    % Close log file
    fclose(MILS_logFile);
    
    % Save MILS_log.mat
    MILS_log = sim_log;
    save(fullfile(sim_log.output_path, "MILS_log.mat"), "MILS_log");   
    
    % Clear redundant variables
    toc
    clear

catch ME %MException struct    
    
    % Close ProgBar only if it has opened
    if exist('ProgBar','var')  
        close(ProgBar); % Progress-bar GUI    
    end

    % Close the log file after logging the error
    sim_close_log_file(ME, sim_log, MILS_logFile, "MILS"); 
end