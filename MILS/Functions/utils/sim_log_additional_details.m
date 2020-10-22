function sim_log = sim_log_additional_details(sim_log)
% Appends the time, date, PC, and path details of the simulation which is
% being run in the `sim_log` variable

    %% Code
    % Check OS
    if ismac
        sim_log.os = "MacOS";
    elseif isunix
        sim_log.os = "Linux";
    elseif ispc
        sim_log.os = "Windows";
    else
        error("OS_Error: Platform not supported");
    end
    
    sim_log.date = datestr(now, 'dd/mm/yyyy'); % Date of simulation
    sim_log.time = datestr(now, 'HH:MM:SS.FFF'); % Time of simulation
    sim_log.computerName = getenv('computername'); % Computer on which simulation is being run
    sim_log.userName= getenv('username'); % User for the simulation
    sim_log.output_path = fullfile(sim_log.path, "Output"); % Output path where the simulation results will be dumped
    sim_log.PP_output_path = fullfile(sim_log.path, "Preprocessing"); % Output path where the preprocessed results will be dumped

end

