function sim_check_required_files(sim_log, mode)
% Checks whether the required files and folders for the `SIS` and/or `MILS`
% exists or not

    %% Code
    if mode == "SIS"
        % Check whether the inputs.csv, simulation_constants.m, 
        % simulation_constants.mat file are in the simulation folder
        if isfile( fullfile(sim_log.path, "inputs.csv") ) == 0
            error('FileNotFoundError: inputs.csv file - missing!');
        elseif isfile( fullfile(sim_log.path, "simulation_constants.m") ) == 0
            error('FileNotFoundError: simulation_constants.m file -  missing!');
        elseif isfile( fullfile(sim_log.path, "simulation_constants.mat") ) == 0
            error('FileNotFoundError: simulation_constants.mat file - missing!');
        elseif isfolder(sim_log.PP_output_path) == 0 && sim_log.SIS.preprocessing == 0
            error('PreprocessingError: Preprocessing needs to be enabled!')
        end
    end
    
end

