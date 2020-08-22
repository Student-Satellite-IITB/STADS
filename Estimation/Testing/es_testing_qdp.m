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
    
    %%algorithm q-Davenport
    q_bi(j,:) = es_qdp(st_op_bi, st_op_ri , v_a);
    
end

writematrix(q_bi, '.\Estimation\Testing\Output\es_q_bi.csv');

