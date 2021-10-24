function sim_log_file_header(sim_log, log_fname, mode)
% Writes the common header information in the corresponding log files
    %% Code
    if mode == "SIS"
        temp_text = "Star Image Simulation";
    elseif mode == "MILS"
        temp_text = "Model-in-Loop Simulation";
    else
        error("ArgumentError: Invalid mode");
    end
    
    %% Write Common Header Info
    
    fprintf(log_fname, '[<img src="https://www.aero.iitb.ac.in/satlab/images/IITBSSP2019.png" width="125"/>](image.png)\n\n');
    fprintf(log_fname,'# ' + temp_text + ' - Log File\n\n');
    fprintf(log_fname,'### Simulation ID: %s\n\n', sim_log.sim_ID);
        
    % Simulation Details
    fprintf(log_fname,'### Simulation - Details\n');
    fprintf(log_fname,'* **Operator**: %s\n', sim_log.operator);
    fprintf(log_fname,'* **Operator ID**: %s\n', sim_log.operator_ID);
    fprintf(log_fname, '* **Date**: %s\n', sim_log.date);
    fprintf(log_fname, '* **Time**: %s\n', sim_log.time);
    fprintf(log_fname, '* **Computer**: %s\n', sim_log.computerName);
    fprintf(log_fname, '* **Operating System**: %s\n', sim_log.os);
    fprintf(log_fname, '* **User**: %s\n', sim_log.userName);
    

    %% Write Mode-specifc Model Info
    
    if mode == "SIS"
        fprintf(log_fname, '* **SIS Folder Path**: %s\n\n',sim_log.path);
        % Star Image Simulation Details
        fprintf(log_fname,'### Star Image Simulation - Details\n');
        fprintf(log_fname,'* **Version**: %s\n', sim_log.SIS.version);
        if sim_log.SIS.preprocessing == 1
            fprintf(log_fname,'* **Preprocessing**: Enabled\n\n');
        else
            fprintf(log_fname,'* **Preprocessing**: Disabled\n\n');
        end
        fprintf(log_fname,'---\n\n');
        
        disp("Done: Generate SIS_log.md");
        
    elseif mode == "MILS"
        % Model-in-Loop Simulation Details
        fprintf(log_fname, '* **SIS Folder Path**: %s\n\n',sim_log.SIS_path);
        fprintf(log_fname,'\n### Model-in-Loop Simulation - Details\n');
        fprintf(log_fname,'* **Feature Extraction - Algorithm**: %s\n', sim_log.MILS.fe_data.algo);
        fprintf(log_fname,'* **Star-Matching - (Lost-in-Space Mode) Algorithm**: %s\n', sim_log.MILS.sm_data.LIS_algo);
        fprintf(log_fname,'* **Star-Matching - (Tracking Mode) Algorithm**: %s\n', sim_log.MILS.sm_data.TM_algo);
        if sim_log.MILS.sm_data.LIS_redundancy 
            fprintf(log_fname,'* **Star-Matching - Lost-in-Space Redundancy**: Enabled\n');
        else
            fprintf(log_fname,'* **Star-Matching - Lost-in-Space Redundancy**: Disabled\n');
        end
        fprintf(log_fname,'* **Estimation - Algorithm**: %s\n\n', sim_log.MILS.es_data.algo);
        fprintf(log_fname,'---\n\n');

        disp("Done: Generate MILS_log.md");
    end    
end