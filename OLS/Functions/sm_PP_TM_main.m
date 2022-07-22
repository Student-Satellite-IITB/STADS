function sm_pp_TM_output = sm_PP_TM_main(SM_const,sim_log)
    % Main function that runs the Preprocessing Star-Matching Tracking Mode
    % block

    %% Code
    write_path = sim_log.PP_output_path;
%     sm_TM_SNT_main;
    % Read - Guide Star Catalogue
    sm_GD_SC = readmatrix(write_path + '\sm_Guide_Star_Catalogue.csv');

% Read - Preprocessed Star Catalogue (which contains the star pairs)
    sm_PP_SC = readmatrix(write_path + '\sm_Preprocessed_Star_Catalogue.csv');
    sm_catalogues.sm_GD_SC = sm_GD_SC;
    sm_catalogues.sm_PP_SC = sm_PP_SC;
    
    sm_TM_SNT =  sm_TM_gnrt_SNT(SM_const.TM, sm_catalogues, true);
    
    sm_pp_TM_output.CONST_TM.sm_GD_SC = sm_GD_SC;
    sm_pp_TM_output.CONST_TM.sm_PP_SC = sm_PP_SC;
    sm_pp_TM_output.CONST_TM.sm_SNT = sm_TM_SNT;
    
    sm_TM_SNT_table = array2table(sm_TM_SNT);
    writetable(sm_TM_SNT_table, write_path + '\sm_Star_Neighbourhood_Table_TM.csv');

end