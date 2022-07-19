function MILS_log = MILS_main(sim_log,ES_const,FE_const,SM_const, MILS_logFile)
% This is the main function to run Model In-Loop Simulation

% Load Star-Matching - Preprocessed Data
load(sim_log.MILS.PP_LIS_outputFileName, 'sm_PP_LIS_output');
load(sim_log.MILS.PP_TM_outputFileName, 'sm_PP_TM_output');

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
        save('variables', 'fe_output','SM_const','sm_PP_LIS_output');
        sm_output = sm_LIS_main(sis_output, fe_output, SM_const, sm_PP_LIS_output, sim_log.MILS.sm_data.LIS_algo); %Execute SM (LIS)
        disp('ran SM');
        disp(height(sm_output.Matched));  
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
        %{
        es_output.accuracy = es_accuracy(sis_output,es_output.q_bi);
        %}
    else
        iter_info.es_status = "Fail!"; % Store iteration status
        es_output = 0; % Create dummy variable
    end
    
    
            
    % Write log file & Estimation output        
    save(iter_info.outputFileName, "es_output", "iter_info", "-append"); % Append ES output to .mat file   
    fprintf(MILS_logFile,'%s|', iter_info.es_status); % Write log file entry - ES
        
    %% Finding Error in the output
    sim_err = sim_error(sis_output.attitude, es_output);
    save(iter_info.outputFileName, "sim_err", "iter_info", "-append"); % Append sim_error to .mat file
        
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

    
end

