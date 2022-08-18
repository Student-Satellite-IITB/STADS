function sm_PP_LIS_output = sm_PP_LIS_main(SM_const, sim_log)
    % Main function that runs the Preprocessing Star-Matching 
    % (Lost-in-Space) block

    %% Code
    
    write_path = sim_log.PP_output_path;
    
    sm_gnrt_catalogues(SM_const, write_path);
    
    sm_PP_LIS_output = sm_gnrt_LIS_catalogues(SM_const, write_path);
    
    
