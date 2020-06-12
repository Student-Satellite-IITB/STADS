%%
% figure();
% histfit(F_correct);
% hold on
% histfit(F_incorrect);
% histfit(F_fail);
% plot((1:N), ones(N)*3, 'k', 'LineWidth', 1.5);
% hold off
% legend('Correct', 'Correct', 'Incorrect', 'Incorrect', 'Fail', 'Fail');
% title('Noise = ' + string(st_add_noise) + ', \delta = ' + string(st_DELTA_new))
% yticks([1:1:max(F_total)]);
% grid();

%%
figure();
plot(F_total, '-ko', 'LineWidth', 2.5, 'MarkerSize', 8, 'MarkerEdgeColor','k', 'MarkerFaceColor',[.49 1 .63]);
hold on
plot(F_correct, '-g^', 'LineWidth', 2 );
plot(F_incorrect, '-r^', 'LineWidth', 2.2);
plot(F_fail, '-bs', 'LineWidth', 1.5);
plot(F_false_fail, '-ms', 'LineWidth', 1.5);
plot((1:N), ones(N)*3, 'k', 'LineWidth', 1.5);
plot((1:N), 3)
hold off
legend('Total', 'Correct', 'Incorrect', 'Fail', 'False Fail');
%yticks([1:1:max(F_total)]);
title('Noise = ' + string(st_add_noise) + ', \delta = ' + string(st_DELTA_new))
grid();

