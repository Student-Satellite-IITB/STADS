function sim_log = sm_PP_main(sim_log,SM_const,MILS_logFile)
% This function is the main function to run preprocessing for Star Matching

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



end

