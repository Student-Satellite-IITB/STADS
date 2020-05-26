%%Add path to functions
addpath(genpath('Estimation'));

%%Read Input
%input from star matching
load('.\Input\es_input.mat');

%weights(currently taken each as 1)
v_a = ones(n_st_strs, 1);

%input epsilon(measure accepted value of Lost function)
epsilon = readmatrix('.\Input\es_epsilon');

%%algorithm Quest1
%Common part for QuEST
[m_B, v_z, lamnot] = es_quest_common(st_op_bi, st_op_ri , v_a);

%finding largest eigenvalue
lam = es_quest_newton(m_B, v_z, lamnot, epsilon);

%finding the quaternion
q_bi = es_quest_1_final(m_B, v_z, lam);

%%Output from Estimation
writematrix(q_bi, '.\Output\es_q_bi.csv');
