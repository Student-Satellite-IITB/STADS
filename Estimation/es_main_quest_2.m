
%%Reads Input
%input from star matching
load('.\Estimation\Input\es_input.mat');


%weights(currently taken each as 1)
%v_a is a column vector with each element is weight for the corresponding
%bi and ri
v_a = ones(st_N_Match, 1);

%%removing the first column in st_op_bi and st_op_ri
%first column of st_op_bi are the feature extraction IDs and the first
%column of st_op_ri are the corresponding SSP-ID of the matched stars. This
%information is not used for during estimation.
st_op_bi_reduced = st_op_bi(:,2:4);
st_op_ri_reduced = st_op_ri(:,2:4);


%input epsilon(measure accepted value of Lost function)
epsilon = readmatrix('.\Estimation\Input\es_epsilon');

%%algorithm Quest2
%Common part for QuEST
[m_B, v_z, lamnot] = es_quest_common(st_op_bi_reduced, st_op_ri_reduced , v_a);

%finding largest eigenvalue
lam = es_quest_newton(m_B, v_z, lamnot, epsilon);

%finding the quaternion using the calculated eigenvalue
q_bi = es_quest_2_final(m_B, v_z, lam);

%%Output from Estimation
writematrix(q_bi, '.\Estimation\Output\es_q_bi.csv');
