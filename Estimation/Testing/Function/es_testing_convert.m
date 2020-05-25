function [] = es_testing_convert(i)
%the convert function take input from the csv file created using the
%test code and convert it into the es_input.mat format which is
%compatible with our main code. It doesn't convert the whole q_bi,
%whereas is does so one row at a time i.e one quaterinon at a time i.e.
%the test case number

T=readtable('.\Estimation\Testing\Input\es_testcases.csv');

%the test code creates 5 sets of bi and ri therefore st_N_Match will always
%equal to 5
st_N_Match = 5;

st_op_bi = [T.b1_x(i) T.b1_y(i) T.b1_z(i);T.b2_x(i) T.b2_y(i) T.b2_z(i); T.b3_x(i) T.b3_y(i) T.b3_z(i);T.b4_x(i) T.b4_y(i) T.b4_z(i);T.b5_x(i) T.b5_y(i) T.b5_z(i)];
st_op_ri = [T.r1_x(i) T.r1_y(i) T.r1_z(i);T.r2_x(i) T.r2_y(i) T.r2_z(i); T.r3_x(i) T.r3_y(i) T.r3_z(i);T.r4_x(i) T.r4_y(i) T.r4_z(i);T.r5_x(i) T.r5_y(i) T.r5_z(i)];


save('.\Estimation\Testing\Input\es_input.mat', 'st_N_Match', 'st_op_bi', 'st_op_ri');




end

