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
    elseif mode == "MILS"
        % Check whether the inputs.csv, simulation_constants.m, 
        % simulation_constants.mat, .\Output, SIS_log.mat, and the 
        % SIS_log.md files are in the simulation folder
        if isfolder(sim_log.output_path) == 0
            error('FolderNotFoundError: .\Output folder - missing!');
        elseif isfile( fullfile(sim_log.output_path, "SIS_log.mat") ) == 0
            error('FileNotFoundError: SIS_log.mat - missing!');
        elseif isfile( fullfile(sim_log.path, "SIS_log.md") ) == 0
            error('FileNotFoundError: SIS_log.md file - missing!');
        elseif isfile( fullfile(sim_log.path, "simulation_constants.mat") ) == 0
            error('FileNotFoundError: simulation_constants.mat file - missing!');
        elseif isfile( fullfile(sim_log.path, "inputs.csv") ) == 0
            error('FileNotFoundError: inputs.csv file - missing!');
        elseif sim_log.MILS.sm_data.preprocessing == 0 && (~isfile(sim_log.MILS.PP_LIS_outputFileName) || ~isfile(sim_log.MILS.PP_TM_outputFileName) )
            error('PreprocessingError: Preprocessing needs to be enabled!')
        end        
    end    
end

