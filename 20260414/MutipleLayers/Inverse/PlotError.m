clear; clc; close all;

%% =========================
% Layer-wise temperature field MAE
%% =========================
mae_layers = [0.0046, 0.0022, 0.00081];
layer_names = {'Layer 1', 'Layer 2', 'Layer 3'};

figure('Color','w','Position',[100 100 700 500]);
bar(mae_layers, 'FaceColor', [0.95 0.75 0.10], 'LineWidth', 1.0);
set(gca, ...
    'XTick', 1:3, ...
    'XTickLabel', layer_names, ...
    'FontSize', 12, ...
    'LineWidth', 1.0);
ylabel('MAE', 'FontSize', 13);
% title('Temperature field MAE of the three layers', 'FontSize', 13);
title('(a)', 'FontSize', 13);
grid on; box on;

%% =========================
% Relative errors of inverted parameters
%% =========================
% Order: [eta, lambda_f, k, C_f]

true_vals = [ ...
    0.4,    0.17279999999999998, 0.1, 1.6;   % Layer 1
    0.3,    0.1296, 0.1, 2.0;   % Layer 2
    0.3,    0.2160, 0.1, 1.6    % Layer 3
];

inv_vals = [ ...
    0.39422411, 0.16602276, 0.09800974, 1.54790962;  % Layer 1
    0.30694371461868286, 0.1340697556734085, 0.09963539987802505, 2.0566134452819824;  % Layer 2
    0.314542,0.229110, 0.102549,          1.560538           % Layer 3
];






rel_err = abs(inv_vals - true_vals) ./ abs(true_vals) * 100;   % percentage

param_names = {'\eta', '\lambda_f', 'k', 'C_f'};

figure('Color','w','Position',[850 100 900 500]);
bar(rel_err', 'grouped', 'LineWidth', 1.0);
set(gca, ...
    'XTick', 1:4, ...
    'XTickLabel', param_names, ...
    'FontSize', 12, ...
    'LineWidth', 1.0);
ylabel('Relative error (%)', 'FontSize', 13);
xlabel('Parameter', 'FontSize', 13);
% title('Relative errors of inverted parameters in the three layers', 'FontSize', 13);
title('(b)', 'FontSize', 13);
legend(layer_names, 'Location', 'best');
grid on; box on;

%% =========================
% Print relative errors in command window
%% =========================
disp('Relative errors (%) of inverted parameters:')
disp(array2table(rel_err, ...
    'VariableNames', {'eta', 'lambda_f', 'k', 'C_f'}, ...
    'RowNames', layer_names));