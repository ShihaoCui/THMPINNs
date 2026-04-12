% ==========================================
% Sorted Max MAE bar chart (yellow bars)
% ==========================================

clear; clc; close all;

param_names = {'C_f', '\lambda_f', '\eta', '\theta_r', 'k', 'T_f'};
max_mae = [0.159127, 0.656573, 0.832692, 0.080698, 0.415077, 0.007575];

% Sort in descending order
[max_mae_sorted, idx] = sort(max_mae, 'descend');
param_names_sorted = param_names(idx);

% Plot
figure('Color','w');
bar(max_mae_sorted, 'FaceColor', 'c', 'LineWidth', 1.0);

set(gca, ...
    'XTick', 1:numel(param_names_sorted), ...
    'XTickLabel', param_names_sorted, ...
    'FontSize', 11, ...
    'LineWidth', 1.0);

ylabel('Max MAE', 'FontSize', 12);
xlabel('Parameter', 'FontSize', 12);
% title('Sensitivity ranking based on maximum MAE', 'FontSize', 13);
grid on;
box on;