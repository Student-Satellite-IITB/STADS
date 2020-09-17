function q_bi = es_esoq2(sm_output,es_const)
%This is the main function to run the QUEST-2
%   Input:
%       sm_input: input file from Star Matching
%       es_const: file containing the constants required.
%       
%   Output:
%       q_bi: final estimated quaternion

%% Code

%extracting different variables form the star matching output
%column of sm_ouput are the corresponding SSP-ID of the matched stars. This
%information is not used for during estimation.
sm_N_Match = sm_output.N;
sm_op_bi_reduced = [sm_output.op_bi.X,sm_output.op_bi.Y,sm_output.op_bi.Z];
sm_op_ri_reduced = [sm_output.op_ri.X,sm_output.op_ri.Y,sm_output.op_ri.Z];


%weights(currently taken each as 1)
%v_a is a column vector with each element is weight for the corresponding
%bi and ri
v_a = ones(sm_N_Match, 1);


%input epsilon(measure accepted value of Lost function)and mimimum accepted
%value of check_value for sequential rotation
epsilon = es_const.es_epsilon;
es_seq_error = es_const.es_seq_error;

%%algorithm ESOQ2
%First part for ESOQ2, which also includes finding the maximumx eigenvalue
[m_B, v_z, lam] = es_esoq2_start_sim(sm_op_bi_reduced, sm_op_ri_reduced , v_a, epsilon);

%finding the quaternion using the calculated eigenvalue
q_bi = es_esoq2_final_sim(m_B, v_z, lam, es_seq_error);

%if the value of the returned quaternion is [-1;-1;-1;-1] then quest has 
%failed and we must use sequential rotation 
if q_bi == [-1;-1;-1;-1]
    q_bi = es_esoq2_seq_rot_sim(sm_op_bi_reduced, sm_op_ri_reduced , v_a, epsilon, es_seq_error);
end



end

