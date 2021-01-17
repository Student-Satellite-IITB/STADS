function sm_output = sm_LIS_main(sis_output, fe_output, SM_const, sm_PP_LIS_output, LIS_algo)
    % Main function that runs the Star-Matching (Lost-in-Space) block

    %% Code
    if LIS_algo == "Default Block"
        cond = sis_output.data_table.Magnitude <= SM_const.MAG_LIMIT;
        sm_output.N = sum(cond);
        
        sm_output.op_bi = array2table([sis_output.data_table.SSP_ID(cond), sis_output.data_table.r3(cond,:)]);
        sm_output.op_bi.Properties.VariableNames = {'SSP_ID','X','Y','Z'};
        
        sm_output.op_ri = array2table([transpose(1:sm_output.N), sis_output.data_table.r0(cond,:)]);
        sm_output.op_ri.Properties.VariableNames = {'FE_ID', 'X', 'Y', 'Z'};

        sm_output.status = "Done";
            
    elseif LIS_algo == "4-Star Matching"
        sm_output = sm_4SM_main_v4(fe_output, SM_const, sm_PP_LIS_output);
    end
end
