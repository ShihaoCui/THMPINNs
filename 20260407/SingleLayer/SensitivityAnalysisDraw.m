% ==========================================
% Sensitivity analysis - overall MAE plot
% Only plot the first figure
% ==========================================

clear; clc; close all;

% x-axis
ratios = [0.7 0.8 0.9 1.0 1.1 1.2 1.3];
tf_offsets = [-0.3 -0.2 -0.1 0.0 0.1 0.2 0.3];

% MAE_all data
Cf_mae       = [0.159127 0.105104 0.052073 0.000000 0.051149 0.101405 0.150799];
lambdaf_mae  = [0.656573 0.416401 0.198725 0.000000 0.182512 0.350965 0.507086];
eta_mae      = [0.832692 0.540536 0.263533 0.000000 0.251702 0.493080 0.725476];
thetar_mae   = [0.076575 0.051487 0.025966 0.000000 0.026424 0.053319 0.080698];
k_mae        = [0.415077 0.267412 0.129308 0.000000 0.121209 0.234952 0.341802];
Tf_mae       = [0.007101 0.004787 0.002420 0.000000 0.002473 0.004998 0.007575];

% Plot
figure('Color','w');
hold on;
box on;

plot(ratios, Cf_mae,      '-o', 'LineWidth', 1.5, 'MarkerSize', 6, 'DisplayName', 'C_f');
plot(ratios, lambdaf_mae, '-s', 'LineWidth', 1.5, 'MarkerSize', 6, 'DisplayName', '\lambda_f');
plot(ratios, eta_mae,     '-d', 'LineWidth', 1.5, 'MarkerSize', 6, 'DisplayName', '\eta');
plot(ratios, thetar_mae,  '-^', 'LineWidth', 1.5, 'MarkerSize', 6, 'DisplayName', '\theta_r');
plot(ratios, k_mae,       '-v', 'LineWidth', 1.5, 'MarkerSize', 6, 'DisplayName', 'k');

% T_f uses offset rather than multiplier
plot(tf_offsets, Tf_mae,  '-p', 'LineWidth', 1.5, 'MarkerSize', 7, 'DisplayName', 'T_f');

xlabel('Multiplier or offset', 'FontSize', 12);
ylabel('MAE', 'FontSize', 12);
% title('Sensitivity analysis based on MAE', 'FontSize', 13);

legend('Location', 'best', 'FontSize', 11);
grid on;
set(gca, 'FontSize', 11, 'LineWidth', 1.0);

hold off;




