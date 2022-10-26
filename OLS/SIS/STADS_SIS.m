%IIT Bombay, Student Satellite Program
%Star Tracker-based Attitude Determination System (STADS)
%Star Image Simulation
 
%clear
%clc

%Simulation Details
% Manual Entry
sim_log.operator = "Tanmay Ganguli"; % Enter Simulation Operator's Full Name
sim_log.operator_ID = "TG"; % Enter Operator ID
sim_log.sim_ID = "12"; % Enter Simulation Number
sim_log.path = path ;%"C:\Users\Tanmay Ganguli\Documents\STADS\SIS run-1"; % Enter Path of Simulation Folder

% Automated Entry
sim_log = sim_log_additional_details(sim_log);

 

%Star Image Simulation (SIS)
%Model
%Version == NONE  %Will not run SIS
%If SIS is run, the Simulation Details will have to be re-loaded for MILS to run
if ~exist('sim_log', 'var')
    error("SimulationError: Simulation Details Not Loaded! Re-load the details!")
end

sim_log.SIS.preprocessing = true; % Enable pre-processing of SIS
sim_log.SIS.version = "Version - 3"; % Version of SIS

 
%Load Inputs & Constants
if sim_log.SIS.version == "NONE"
    disp("Star Image Simulation - Skipped!")
    
elseif sim_log.SIS.version == "Default Block"
    % Add Simulation Path
    addpath(genpath(sim_log.path));
    
    %% Load Inputs & Constants File
    sim_check_required_files(sim_log, "SIS"); % Check whether required files exit
    
    % Load constants.mat file, and input.csv file
    load( fullfile(sim_log.path, "simulation_constants.mat") );
    INPUT = readtable( fullfile(sim_log.path, "inputs.csv") );   
    
    % Total number of iterations to be performed in the simulation
    sim_log.N_Iter = INPUT.Sl_No(end); 
    
    disp("Done: Load Inputs & Simulation Constants");
else 
    % Add Simulation Path
    addpath(genpath(sim_log.path));
    
    %% Load Inputs & Constants File
    sim_check_required_files(sim_log, "SIS_v3"); % Check whether required files exit
    
    % Load constants.mat file, and input.csv file
    load( fullfile(sim_log.path, "sis_input.mat") );
    %INPUT = readtable( fullfile(sim_log.path, "inputs.csv") );   
    
    % Total number of iterations to be performed in the simulation
    %sim_log.N_Iter = INPUT.Sl_No(end); 
    %sis_input.gen.N_bo = 1;%%%% change this
    sim_log.N_Iter = sis_input.gen.N_bo;
    
    disp("Done: Load Inputs & Simulation Constants");
    
end
%Generate Star Image Simulation - Log File
try
    if sim_log.SIS.version == "NONE"
        disp("Star Image Simulation - Skipped!")
    else
        tic
        % Read SIS-data file
        %if sim_log.SIS.version == "Default Block"
        %    %%%%%% Load Default Block data
        %elseif sim_log.SIS.version == "Version - 3"
        %    %%%%%% Load Version - 3 data
        %end
        
        
        %% Make Output Folder
        if isfolder(sim_log.output_path) == 1
            % Remove ".\Output" from the simulation folder
            [~,~] = rmdir(sim_log.output_path, 's'); 
        end
        mkdir(sim_log.output_path); % Create empty ".\Output" folder
        
        
        %% Make Preprocessing Folder
        if sim_log.SIS.preprocessing == 1 && isfolder(sim_log.PP_output_path) == 1    
            % Remove ".\Output" from the simulation folder
            [~,~] = rmdir(sim_log.PP_output_path, 's'); 
        end 
        
        if sim_log.SIS.preprocessing == 1
            mkdir(sim_log.PP_output_path); % Create empty ".\Output\Preprocessing" folder    
        end  
        
        %% Create SIS_log.txt file
        SIS_logFile = fopen(fullfile(sim_log.path, "SIS_log.md"),'w');
        sim_log_file_header(sim_log,SIS_logFile, "SIS"); % Write header for log file
    end
%Run Star Image Simulation - Preprocessing
    if sim_log.SIS.version == "NONE"
        disp("Star Image Simulation - Skipped")
    else
        sim_log.SIS.PP_outputFileName = fullfile(sim_log.PP_output_path, "SIS_preprocessed_data.mat");
        
        if sim_log.SIS.preprocessing == 0
            fprintf(SIS_logFile,'### Preprocessing - Details\n\n');
            fprintf(SIS_logFile, "Preprocessing Skipped!\n\n");
            
            disp("Star Image Simulation - Preprocessing - Skipped!")
        
        elseif sim_log.SIS.preprocessing == 1
            ProgBar = waitbar(0,'Starting preprocessing...'); % Progress-bar GUI
            tic
            fprintf(SIS_logFile,'### Preprocessing - Details\n\n');
            fprintf(SIS_logFile,'|Status|Time_Taken - (mm:ss.SS)\n');
            fprintf(SIS_logFile, '|:---:|:---:|\n');
            
            %%% Run Preprocessing
            waitbar(0.3, ProgBar, 'Running preprocessing...'); % Progress-bar GUI
            sim_log.PP_T1 = datetime(); % Time at which preprocessing starts
            
            % Excecute SIS Preprocessing
            if sim_log.SIS.version == "Default Block"
                sis_PP_output = sis_PP_main(SIS_const,sim_log.SIS.version,sim_log.SIS.PP_outputFileName);
            else
                sis_PP_output = sis_PP_main(sis_input,sim_log.SIS.version,sim_log.SIS.PP_outputFileName);
            end
            
            
            sim_log.PP_dt = duration(datetime() - sim_log.PP_T1, "Format","mm:ss.SS");   % Time taken to excute SIS Preprocessing
            
            % Save the output file
            waitbar(0.6, ProgBar, 'Saving preprocessing...'); % Progress-bar GUI
            save(sim_log.SIS.PP_outputFileName, 'sis_PP_output', 'sim_log'); % Save .mat file     
            
            % Write log-entry
            fprintf(SIS_logFile,'|Done|%s|\n\n', sim_log.PP_dt);
            toc
            close(ProgBar); % Progress-bar GUI
        end
        
        % Simulation Details
        fprintf(SIS_logFile,'### Simulation - Details\n\n');
        fprintf(SIS_logFile,'|Iter|Status|Time_Taken - (mm:ss.SS)|\n');
        fprintf(SIS_logFile, '|:---:|:---:|:---:|\n');
        
        % Load SIS - Preprocessed Data
        load(sim_log.SIS.PP_outputFileName, 'sis_PP_output');
        
        disp("Done: Star Image Simulation - Preprocessing");
    end
%Run Star Image Simulation
    if sim_log.SIS.version == "NONE"
        disp("Star Image Simulation - Skipped!")  
    elseif sim_log.SIS.version == "Default Block"
        sim_log.T1 = datetime(); % Time at which simulation starts
        disp('Start: Star Image Simulation');
        ProgBar = waitbar(0,'Starting simulation...'); % Progress-bar GUI
        
        %% Start Iterations
        for i = 1:sim_log.N_Iter
            iter_info.i = i; % Store iteration number
            waitbar(i/sim_log.N_Iter, ProgBar, 'Running simulation...'); % Progress-bar GUI
            
            iter_info.t1 = datetime(); % Time at which iteration starts
            
            %% Read Input
            sis_input.attitude = [INPUT.Attitude_1(iter_info.i), INPUT.Attitude_2(iter_info.i), INPUT.Attitude_3(iter_info.i)];
            
            %%% Run Star Image Simulation on single input
            
            sis_output = sis_main(sis_input, SIS_const, sis_PP_output, sim_log.SIS.version); % Execute SIS        
            
            %% Write log file & SIS-output
            
            iter_info.status = sis_output.status; % Store iteration status
            
            % Output filename in which the output data of the current iteration
            % is stored
            iter_info.outputFileName = fullfile(sim_log.output_path, "SIS_iter_" + string(iter_info.i) + ".mat");
            
            % Time taken to excute current iteration
            iter_info.dt = duration(datetime() - iter_info.t1, "Format","mm:ss.SS");  
            
            % Save the output file
            save(iter_info.outputFileName, 'sis_input', 'sis_output', 'iter_info'); % Save .mat file   
    
            % Write log-entry
            fprintf(SIS_logFile,'|%d|%s|%s|\n', round(iter_info.i), iter_info.status, iter_info.dt); % Write log file entry
        end
        close(ProgBar); % Progress-bar GUI
        
        disp('Done: Star Image Simulation');
        
        sim_log.dt = duration(datetime() - sim_log.T1, "Format","mm:ss.SS");   % Time taken to excute entire SIS simulation
        
        % Write log-entry
        fprintf(SIS_logFile, '\n---\n');
        if sim_log.SIS.preprocessing == 1
            sim_log.dt = sim_log.dt + sim_log.PP_dt;
        end
        fprintf(SIS_logFile,'\n**Total Time Taken:** %s\n', sim_log.dt);
        
        % Close log file
        fclose(SIS_logFile);
        
        % Save SIS_log.mat
        SIS_log = sim_log;
        save(fullfile(sim_log.output_path, "SIS_log.mat"), 'SIS_log');
        
        % Clear redundant variables
        toc
        clear
    else
        sim_log.T1 = datetime(); % Time at which simulation starts
        disp('Start: Star Image Simulation');
        ProgBar = waitbar(0,'Starting simulation...'); % Progress-bar GUI
        
        %% Start Iterations
        sis_T = sis_PP_output.sis_SKY2000;
        
        % Dynamics block
        sis_input = sis_dm_main(sis_input);
        
        
        for i = 1:sim_log.N_Iter
            iter_info.i = i; % Store iteration number
            waitbar(i/sim_log.N_Iter, ProgBar, 'Running simulation...'); % Progress-bar GUI
            
            iter_info.t1 = datetime(); % Time at which iteration starts
            
            
            %% Read Input
            sis_input_attitude = sis_input.bo(1,:,i);
            
            %%% Run Star Image Simulation on single input
            
            sis_output = sis_main_v3(sis_input, sis_T,i); % Execute SIS        
            
            %% Write log file & SIS-output
            
            iter_info.status = sis_output.status; % Store iteration status
            
            % Output filename in which the output data of the current iteration
            % is stored
            iter_info.outputFileName = fullfile(sim_log.output_path, "SIS_iter_" + string(iter_info.i) + ".mat");
            
            % Time taken to excute current iteration
            iter_info.dt = duration(datetime() - iter_info.t1, "Format","mm:ss.SS");  
            
            % Save the output file
            save(iter_info.outputFileName, 'sis_input_attitude', 'sis_output', 'iter_info'); % Save .mat file 
            %writematrix(sis_output.image, 'image_'+ string(iter_info.i) +'.txt'); % Generating txt file
            writematrix(table2array(sis_output.data_table(:,14:17)), 'table_'+ string(iter_info.i) +'.csv'); % Generating csv file
    
            % Write log-entry
            fprintf(SIS_logFile,'|%d|%s|%s|\n', round(iter_info.i), iter_info.status, iter_info.dt); % Write log file entry
        end
        close(ProgBar); % Progress-bar GUI
        
        disp('Done: Star Image Simulation');
        
        sim_log.dt = duration(datetime() - sim_log.T1, "Format","mm:ss.SS");   % Time taken to excute entire SIS simulation
        
        % Write log-entry
        fprintf(SIS_logFile, '\n---\n');
        if sim_log.SIS.preprocessing == 1
            sim_log.dt = sim_log.dt + sim_log.PP_dt;
        end
        fprintf(SIS_logFile,'\n**Total Time Taken:** %s\n', sim_log.dt);
        
        % Close log file
        fclose(SIS_logFile);
        
        % Save SIS_log.mat
        SIS_log = sim_log;
        save(fullfile(sim_log.output_path, "SIS_log.mat"), 'SIS_log');
        
        % Clear redundant variables
        toc
        %clear
    end
catch ME %MException struct    
    
    % Close ProgBar only if it has opened
    if exist('ProgBar','var')  
        close(ProgBar); % Progress-bar GUI    
    end

    % Close the log file after logging the error
    sim_close_log_file(ME, sim_log, SIS_logFile, "SIS"); 
    
end
