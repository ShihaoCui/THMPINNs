clear all;
clc;
close all;

load('T_fdm_pinn_only.mat')

T_field_pinn = T_pinn;
T_fdm_interp = T_fdm;
error = T_field_pinn-T_fdm_interp;

% -------------------------------------------------
% 基本参数
% 假设矩阵尺寸为: [depth, time]
% -------------------------------------------------
[nz, nt] = size(T_field_pinn);

t = linspace(0, 365, nt);   % 时间
z = linspace(0, 5, nz);     % 深度

% -------------------------------------------------
% 自定义 bwr colormap
% -------------------------------------------------
n = 256;
bottom = [0 0 1];
middle = [1 1 1];
top = [1 0 0];

r = [linspace(bottom(1), middle(1), n/2), linspace(middle(1), top(1), n/2)]';
g = [linspace(bottom(2), middle(2), n/2), linspace(middle(2), top(2), n/2)]';
b = [linspace(bottom(3), middle(3), n/2), linspace(middle(3), top(3), n/2)]';
bwr = [r g b];

% -------------------------------------------------
% 统一温度图色轴范围
% -------------------------------------------------
temp_min = min([T_fdm_interp(:); T_field_pinn(:)]);
temp_max = max([T_fdm_interp(:); T_field_pinn(:)]);

% -------------------------------------------------
% 误差图对称色轴
% -------------------------------------------------
err_max = max(abs(error(:)));

% -------------------------------------------------
% 图1：温度场和误差场
% -------------------------------------------------
figure('Position', [100, 100, 1400, 400]);

subplot(1,3,1)
imagesc([0 365], [0 5], T_fdm_interp);
set(gca, 'YDir', 'reverse');
colormap(gca, bwr);
caxis([temp_min temp_max]);
xlabel('Time (days)');
ylabel('Depth (m)');
title('(c)');
cb1 = colorbar;
cb1.Label.String = 'FDM T(°C)';

subplot(1,3,2)
imagesc([0 365], [0 5], T_field_pinn);
set(gca, 'YDir', 'reverse');
colormap(gca, bwr);
caxis([temp_min temp_max]);
xlabel('Time (days)');
ylabel('Depth (m)');
title('(d)');
cb2 = colorbar;
cb2.Label.String = 'PINNs T (°C)';

subplot(1,3,3)
imagesc([0 365], [0 5], error);
set(gca, 'YDir', 'reverse');
colormap(gca, bwr);
caxis([-err_max err_max]);
xlabel('Time (days)');
ylabel('Depth (m)');
title('(e)');
cb3 = colorbar;
cb3.Label.String = 'T difference (°C)';








% -------------------------------------------------
% 目标深度和时刻
% -------------------------------------------------
depth_targets = [0 1 2 3 4 5];
time_targets  = [0 50 100 150 200 250 300 350];

depth_idx = zeros(size(depth_targets));
for i = 1:length(depth_targets)
    [~, depth_idx(i)] = min(abs(z - depth_targets(i)));
end

time_idx = zeros(size(time_targets));
for i = 1:length(time_targets)
    [~, time_idx(i)] = min(abs(t - time_targets(i)));
end

% 用于PINNs的marker
markers = {'o', '^', 's', 'd', 'v', '>', '<', 'p'};

% -------------------------------------------------
% 图2：所有深度放在一张图上
% FDM = 实线
% PINNs = 仅符号
% -------------------------------------------------
figure('Position', [100, 180, 1000, 600]);
hold on;

colors_depth = lines(length(depth_targets));

for i = 1:length(depth_targets)
    % FDM: 实线
    plot(t, T_fdm_interp(depth_idx(i), :), ...
        '-', 'LineWidth', 1.8, 'Color', colors_depth(i,:));

    % PINNs: 只画符号，隔点取样避免太密
    sample_idx = 1:round(nt/40):nt;
    plot(t(sample_idx), T_field_pinn(depth_idx(i), sample_idx), ...
        'LineStyle', 'none', ...
        'Marker', markers{i}, ...
        'MarkerSize', 6, ...
        'MarkerEdgeColor', colors_depth(i,:), ...
        'Color', colors_depth(i,:));
end

xlabel('Time (days)');
ylabel('Temperature (°C)');
title('(a)');
grid on;
box on;

legend_entries = cell(1, 2*length(depth_targets));
for i = 1:length(depth_targets)
    legend_entries{2*i-1} = ['FDM, z = ', num2str(depth_targets(i)), ' m'];
    legend_entries{2*i}   = ['PINNs, z = ', num2str(depth_targets(i)), ' m'];
end
legend(legend_entries, 'Location', 'eastoutside');

% -------------------------------------------------
% 图3：所有时刻放在一张图上
% FDM = 实线
% PINNs = 符号
% -------------------------------------------------
figure('Position', [120, 220, 1000, 600]);
hold on;

colors_time = lines(length(time_targets));

for i = 1:length(time_targets)
    % FDM: 实线
    plot(T_fdm_interp(:, time_idx(i)), z, ...
        '-', 'LineWidth', 1.8, 'Color', colors_time(i,:));

    % PINNs: 符号
    sample_idx = 1:round(nz/25):nz;
    plot(T_field_pinn(sample_idx, time_idx(i)), z(sample_idx), ...
        'LineStyle', 'none', ...
        'Marker', markers{i}, ...
        'MarkerSize', 6, ...
        'MarkerEdgeColor', colors_time(i,:), ...
        'Color', colors_time(i,:));
end

set(gca, 'YDir', 'reverse');
xlabel('Temperature (°C)');
ylabel('Depth (m)');
title('(b)');
grid on;
box on;

legend_entries = cell(1, 2*length(time_targets));
for i = 1:length(time_targets)
    legend_entries{2*i-1} = ['FDM, day = ', num2str(time_targets(i))];
    legend_entries{2*i}   = ['PINNs, day = ', num2str(time_targets(i))];
end
legend(legend_entries, 'Location', 'eastoutside');