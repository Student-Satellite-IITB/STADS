
%%Reads Input
%input from star matching
load('.\Estimation\Input\es_input.mat');


%weights(currently taken each as 1)
%v_a is a column vector with each element is weight for the corresponding
%bi and ri
v_a = ones(N, 1);

%%removing the first column in st_op_bi and st_op_ri
%first column of st_op_bi are the feature extraction IDs and the first
%column of st_op_ri are the corresponding SSP-ID of the matched stars. This
%information is not used for during estimation.
sm_op_bi_reduced = op_bi(:,2:4);
sm_op_ri_reduced = op_ri(:,2:4);


%input epsilon(measure accepted value of Lost function)
epsilon = readmatrix('.\Estimation\Input\es_epsilon');

%%algorithm Quest2
%Common part for QuEST
[m_B, v_z, lamnot] = es_quest_common(sm_op_bi_reduced, sm_op_ri_reduced , v_a);

%finding largest eigenvalue
lam = es_quest_newton(m_B, v_z, lamnot, epsilon);

%finding the quaternion using the calculated eigenvalue
q_bi = es_quest_2_final(m_B, v_z, lam);

%if the value of the returned quaternion is [-1;-1;-1;-1] then quest has 
%failed and we must use sequential rotation 
if q_bi == [-1;-1;-1;-1]
    q_bi = es_quest_2_seq_rot(sm_op_bi_reduced, sm_op_ri_reduced , v_a);
end

%saving the quaternion in the input folder also for the case when the 
%(o * eye(3) - m_S) matrix is near zero
writematrix(q_bi, '.\Estimation\Input\es_q_bi.csv');

%%Output from Estimation
writematrix(q_bi, '.\Estimation\Output\es_q_bi.csv');
