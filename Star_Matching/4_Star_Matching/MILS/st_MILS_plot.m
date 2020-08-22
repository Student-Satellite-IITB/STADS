clc
clear
set(0,'defaultTextInterpreter','latex');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plots the summary result of st_MILS.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
file_base_ip = '.\Star_Matching\4_Star_Matching\MILS\Output\Star_Matching_Output\';
file_base_op = '.\Star_Matching\4_Star_Matching\MILS\Output\Plots\';
%% Input

file_loc_ip = strcat(file_base_ip , 'st_summary_ST.mat');
load(file_loc_ip);

%% Figure Name
% Enter Threshold value
T = num2str(T_HOLD);
%% Plot
X = 1: height(data_table);
figure();
N_True = data_table.st_N_True;
N_False = data_table.st_N_False;
N_Miss = data_table.st_N_Miss;
N_str = data_table.fe_n_str;

hold on
plot(X, N_True, '-sg', 'LineWidth', 1.5);
plot(X, N_False, '-sr', 'LineWidth', 1.5);
plot(X, N_Miss, '-sb', 'LineWidth', 1.5);
plot(X, N_str, '-sk', 'LineWidth', 1.5);
yline(6, '--k');
hold off
xlim([X(1) X(end)])
legend('True', 'False', 'Miss', 'Image', 'N_{TH}:6', 'Location', 'north');
xlabel('Image Number');
xticks(X);
ylabel('Number of such instances $\rightarrow$');
title(strcat('ST - Summary | Threshold value: ', T));

print(strcat(file_base_op, 'threshold_', T), '-dpng', '-r500'); 

%% Without Verification step
% Enter Threshold value
T = num2str(T_HOLD);
% Plot
X = 1: height(data_table);

N_True = data_table.st_N_True + data_table.st_N_Miss;
N_False = data_table.st_N_Match-N_True;
N_str = data_table.fe_n_str;

figure();
hold on
plot(X, N_True, '-sg', 'LineWidth', 1.5);
plot(X, N_False, '-sr', 'LineWidth', 1.5);
plot(X, N_str, '-sk', 'LineWidth', 1.5);
yline(6, '--k');
hold off
xlim([X(1) X(end)])
legend('True', 'False', 'Image', 'N_{TH}:6', 'Location', 'north');
xlabel('Image Number');
xticks(X);
ylabel('Number of such instances $\rightarrow$');
title(strcat('ST - Summary | No Verifiaction | Threshold value: ', T));

print(strcat(file_base_op, 'no_ver_threshold_', T), '-dpng', '-r500'); 
disp('Image Generation: Done');