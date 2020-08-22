%%making the values to account for more decimals
format long;


%q_bi here is like the quat matrix.
%In the quat matrix each row corresponds to a quaternion
%the test code creates 20 test cases at a time therefore q_bi has 20 rows
q_bi = zeros(20,4);

for j = 1:20
    %the convert function take input from the csv file created using the
    %test code and convert it into the es_input.mat format whic is
    %compatible with our main code. It doesn't convert the whole q_bi,
    %whereas is does so one row at a time i.e one quaterinon at a time i.e.
    %the test case number
    
    es_testing_convert(j);
    
    %%Read Input
    %input from star matching
    load('.\Estimation\Testing\Input\es_input.mat');
    
    %weights(currently taken each as 1)
    v_a = ones(st_N_Match, 1);
    
    %input epsilon(measure accepted value of Lost function)
    epsilon = readmatrix('.\Estimation\Testing\Input\es_epsilon');
    
    %%algorithm Quest1
    %Common part for QuEST
    [m_B, v_z, lamnot] = es_quest_common(st_op_bi, st_op_ri , v_a);
    
    %finding largest eigenvalue
    lam = es_quest_newton(m_B, v_z, lamnot, epsilon);
    
    %finding the quaternion
    q_bi(j,:) = es_quest_1_final(m_B, v_z, lam);
    %%Output from Estimation
end

writematrix(q_bi, '.\Estimation\Testing\Output\es_q_bi.csv');

