clear; clc; close all;

params = {'\eta', '\lambda_f', 'k', 'C_f'};

true_vals = [0.4, 0.1728, 0.1, 1.6];

inv_05 = [0.398343026638031, 0.17087575793266296, 0.1000002920627594, 1.5667058229446411];  % 改成0.5 m结果
inv_10 = [0.398343026638031, 0.17087575793266296, 0.1000002920627594, 1.5667058229446411];  % 改成1 m结果

err_05 = abs(inv_05 - true_vals) ./ abs(true_vals) * 100;
err_10 = abs(inv_10 - true_vals) ./ abs(true_vals) * 100;

Y = [err_05; err_10]';

figure('Position',[100 100 850 500]);
b = bar(Y, 'grouped');

b(1).LineWidth = 1.2;
b(2).LineWidth = 1.2;

set(gca, 'XTickLabel', params, 'FontSize', 13);
xlabel('Parameter');
ylabel('Relative error (%)');
legend({'0.5 m observations', '1 m observations'}, 'Location', 'best');
grid on;
box on;
title('Relative errors of identified parameters');