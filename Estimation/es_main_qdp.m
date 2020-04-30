%%Add path to functions
addpath(genpath('Estimation'));

%%Read Input
%input from star matching
load('.\Input\es_input.mat');

%weights(currently taken each as 1)
es_a = ones(n_st_strs, 1);

%%algorithm q-Davenport
q_bi = es_qdp(st_op_bi, st_op_ri , es_a);

%%Output from Estimation
writematrix(q_bi, '.\Output\es_q_bi.csv');