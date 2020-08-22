
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

%%algorithm ESOQ2
%First part for ESOQ2, which also includes finding the maximumx eigenvalue
[m_B, v_z, lam] = es_esoq2_start(st_op_bi_reduced, st_op_ri_reduced , v_a, epsilon);

%finding the quaternion using the calculated eigenvalue
q_bi = es_esoq2_final(m_B, v_z, lam);

%if the value of the returned quaternion is [-1;-1;-1;-1] then quest has 
%failed and we must use sequential rotation 
if q_bi == [-1;-1;-1;-1]
    q_bi = es_esoq2_seq_rot(st_op_bi_reduced, st_op_ri_reduced , v_a, epsilon);
end

%%Output from Estimation
writematrix(q_bi, '.\Estimation\Output\es_q_bi.csv');
