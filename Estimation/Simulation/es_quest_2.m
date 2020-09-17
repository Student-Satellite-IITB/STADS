function q_bi = es_quest_2(sm_output,es_const)
%This is the main function to run the QUEST-2
%   Input:
%       sm_input: input file from Star Matching
%       es_const: file containing the constants required.
%       
%   Output:
%       q_bi: final estimated quaternion

%% Code

%extracting different variables form the star matching output
sm_N_Match = sm_output.N;
sm_op_bi   = table2array(sm_output.op_bi);
sm_op_ri   = table2array(sm_output.op_ri);


%weights(currently taken each as 1)
%v_a is a column vector with each element is weight for the corresponding
%bi and ri
v_a = ones(sm_N_Match, 1);

%%removing the first column in st_op_bi and st_op_ri
%first column of st_op_bi are the feature extraction IDs and the first
%column of st_op_ri are the corresponding SSP-ID of the matched stars. This
%information is not used for during estimation.
sm_op_bi_reduced = sm_op_bi(:,2:4);
sm_op_ri_reduced = sm_op_ri(:,2:4);

%input epsilon(measure accepted value of Lost function)and mimimum accepted
%value of check_value for sequential rotation
epsilon = es_const.es_epsilon;
es_seq_error = es_const.es_seq_error;

%%algorithm Quest2
%Common part for QuEST
[m_B, v_z, lamnot] = es_quest_common_sim(sm_op_bi_reduced, sm_op_ri_reduced , v_a);

%finding largest eigenvalue
lam = es_quest_newton_sim(m_B, v_z, lamnot, epsilon);

%finding the quaternion using the calculated eigenvalue
q_bi = es_quest_2_final_sim(m_B, v_z, lam, es_seq_error);

%if the value of the returned quaternion is [-1;-1;-1;-1] then quest has 
%failed and we must use sequential rotation 
if q_bi == [-1; -1; -1; -1]
    %previous quaternion
    q_bi_prev = es_const.es_q_bi_prev;
    
    q_bi = es_quest_2_seq_rot_sim(sm_op_bi_reduced, sm_op_ri_reduced , v_a, epsilon, es_seq_error, q_bi_prev);
end


%Saving the final quaternion into the es_const.es_q_bi_prev
es_const.es_q_bi_prev = q_bi;

end

