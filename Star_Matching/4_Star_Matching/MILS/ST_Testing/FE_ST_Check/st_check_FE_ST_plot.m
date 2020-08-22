clc
clear
set(0,'defaultTextInterpreter','latex');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plots the summary result of st_check_FE_ST.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
file_base_ip = '.\Star_Matching\4_Star_Matching\MILS\ST_Testing\FE_ST_Check\';
file_base_op = '.\Star_Matching\4_Star_Matching\MILS\ST_Testing\FE_ST_Check\Plots\';
%% Input

file_loc_ip = strcat(file_base_ip , 'st_summary_FE_ST_check.mat');
load(file_loc_ip);

%% Figure Name
% Enter Trime Star ID
T = num2str(Trim_Star_ID);
%name = strcat(file_base_op, name, '
%% Plot
X = 1: height(data_table);

N_True = data_table.st_N_True;
N_False = data_table.st_N_False;
N_Miss = data_table.st_N_Miss;
N_str = data_table.fe_n_str;

hold on
plot(X, N_True, '-sg', 'LineWidth', 1.5);
plot(X, N_False, '-sr', 'LineWidth', 1.5);
plot(X, N_Miss, '-sb', 'LineWidth', 1.5);
plot(X, N_str, '-sk', 'LineWidth', 1.5);
yline(8, '--k');
hold off
xlim([X(1) X(end)])
legend('True', 'False', 'Miss', 'Image', '\delta_{TM}', 'Location', 'north');
xlabel('Image Number');
xticks(X);
ylabel('Number of such instances $\rightarrow$');
title(strcat('FE-ST - Summary | Trim-Star-ID: ', T));

print(strcat(file_base_op, T), '-dpng', '-r500'); 
disp('Image Generation: Done');