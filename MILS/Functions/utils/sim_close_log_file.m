function sim_close_log_file(ME, sim_log, log_fname, mode)
% Stores the error thrown in the corresponding file, and closes the log
% file

    %% Code
    if mode == "SIS"
        temp_text = "Star Image Simulation";
    elseif mode == "MILS"
        temp_text = "Model-in-Loop Simulation";
    else
        error("ArgumentError: Invalid mode");
    end
    
    disp('Stopped: ' + temp_text);
    fprintf(log_fname, '\n\n---\n');
    fprintf(log_fname, '\n\n### Error Thrown\n');    
    fprintf(log_fname, '\n|Error Identifier|%s|\n', ME.identifier);
    fprintf(log_fname, '|:---:|:---:|\n');
    fprintf(log_fname, '|**Error Message**|%s|\n', ME.message);
    temp = ME.stack.file; 
    fprintf(log_fname, '|**Error File**|%s|\n', temp);
    temp = ME.stack.line;
    fprintf(log_fname, '|**Line Number**|%d|\n', temp);
    
    save( fullfile(sim_log.path, 'error_vars.mat') ); % Save error variables
    fprintf(log_fname, '### Saved workspace variables for debugging\n');
    fprintf(log_fname, '* **Saved at**: %s\n', sim_log.path + "\error_vars.mat");
    fprintf(log_fname, '\n---\n');
    
    % Print total time taken only if the variable exists within the sim_log
    % structure
    if isfield(sim_log,'T1')  
        sim_log.dt = duration(datetime() - sim_log.T1, "Format","mm:ss.SS");
        
        if mode == "SIS" && sim_log.SIS.preprocessing == 1 
            sim_log.dt = sim_log.dt + sim_log.PP_dt; 
        elseif mode == "MILS" && sim_log.MILS.sm_data.preprocessing == 1
            sim_log.dt = sim_log.dt + sim_log.PP_LIS_dt + sim_log.PP_TM_dt;
        end

        fprintf(log_fname,'\n**Total Time Taken:** %s\n', sim_log.dt);
    end    
    fclose(log_fname); % Close log file
    rethrow(ME); % Rethrow error
end