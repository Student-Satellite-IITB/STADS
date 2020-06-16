clc
clear
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot the result of st_Delta_Analysis.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Input
% Folder - Feature Extraction Input
file_base_ip = '.\Star_Matching\4_Star_Matching\MILS\ST_Testing\Delta_Analysis\';
file_base_op = '.\Star_Matching\4_Star_Matching\MILS\ST_Testing\Delta_Analysis\';

%% Plotter - Coarse DELTA
file_loc_ip = strcat(file_base_ip , 'st_DELTA_summary_coarse.mat');
load(file_loc_ip);
fact = 100/15;
mark = 0;

x = DELTA_arr;
y1 = c_TrackingMode * fact;
y2 = c_GreaterThanDelta * fact;

i = 13;
params = 'Center';
c_TM = st_movavgFilt(y1', i, params);
c_GD = st_movavgFilt(y2', i, params);

%%
figure();
hold on 
plot(x, y1, '-go', 'MarkerFaceColor',[.49 1 .63]);
plot(x, c_TM, 'r', 'LineWidth', 1.7);
%plot(x, ones(length(x))*mark, 'k', 'LineWidth', 1.4);
hold off
leg1 = legend('$\ge 4$',strcat('Moving avg: ',num2str(i)), 'Location', 'northwest');
set(leg1,'Interpreter','latex');
title('$\delta$ vs Occurance Rate','Interpreter','latex')
ylabel('Occurance rate (%) \rightarrow');
xlabel('\delta \rightarrow');
xlim([x(1), x(end)]);

figure();
hold on
plot(x, y2, '-go', 'MarkerFaceColor',[.49 1 .63]);
plot(x, c_GD, 'r', 'LineWidth', 1.7);
%plot(x, ones(length(x))*mark, 'k', 'LineWidth', 1.4);
hold off
leg1 = legend('$\ge \delta_{TM}$',strcat('Moving avg: ',num2str(i)), 'Location', 'northwest');
set(leg1,'Interpreter','latex');
title('$\delta$ vs Occurance Rate','Interpreter','latex')
ylabel('Occurance rate (%) \rightarrow');
xlabel('\delta \rightarrow');
xlim([x(1), x(end)]);