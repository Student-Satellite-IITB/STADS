function sm_output = sm_LIS_main(sis_output, fe_output, SM_const, sm_PP_LIS_output, LIS_algo)
    % Main function that runs the Star-Matching (Lost-in-Space) block

    %% Code
        if LIS_algo == "Default Block"
            sm_output.N = height(fe_output.centroids);
            sm_output.op_bi = sis_output.data_table(:,{'r3'});
            sm_output.op_ri = sis_output.data_table(:,{'r0'});
            sm_output.status = "Done";
            
        elseif LIS_algo == "4-Star Matching"
            sm_output = sm_4SM_main_v4(fe_output, SM_const, sm_PP_LIS_output);
        end

end
