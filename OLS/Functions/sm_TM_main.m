function sm_output = sm_TM_main(fe_output, sm_output_curr, sm_output_prev, SM_const, TM_algo,sm_PP_TM_output)
% Main function that runs the Star-Matching (Tracking Mode) block

%% Code
    if TM_algo == "Default Block" 
        % Code here

    elseif TM_algo == "Unnamed-1"
        % Code here
        sort_dx = true;
        sort_before_match = true;
        sm_catalogues.sm_GD_SC = sm_PP_TM_output.CONST_TM.sm_GD_SC;
        sm_catalogues.sm_PP_SC = sm_PP_TM_output.CONST_TM.sm_PP_SC;
        sm_TM_SNT = sm_PP_TM_output.CONST_TM.sm_SNT;
        sm_output = sm_TM_mainscript(fe_output, sm_output_curr, sm_output_prev, SM_const.TM, sm_TM_SNT, sm_catalogues, sort_dx, sort_before_match);
    end
    
end