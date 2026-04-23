%% =========================
% 图2：将 6 个时间点全部画在同一个图中
% 颜色区分时间，线型区分方法
% =========================
time_list = [0 0.1 0.2 0.3 0.4 0.5];

% 统一纵轴范围
allT = [Data_real(:); T_fdm(:); T_pinn(:)];
ymin = floor(min(allT));
ymax = ceil(max(allT));

figure('Position',[120 80 1000 650]);
ax = axes;
hold(ax,'on');
box(ax,'on');

% 6 个时间点对应 6 个颜色
colors = lines(length(time_list));

for i = 1:length(time_list)
    t0 = time_list(i);

    [~, idx_real] = min(abs(t_real - t0));
    [~, idx_fdm]  = min(abs(t_fdm_year - t0));
    [~, idx_pinn] = min(abs(t_pinn_year - t0));

    % 实际数据
    T_real_profile = Data_real(idx_real,:);

    % FDM: 取 4~8 m 对应位置
    T_fdm_profile = zeros(size(depth_real));
    for j = 1:length(depth_real)
        [~, ix] = min(abs(x_fdm - depth_real(j)));
        T_fdm_profile(j) = T_fdm(ix, idx_fdm);
    end

    % PINNs: 取 4~8 m 对应位置
    T_pinn_profile = zeros(size(depth_real));
    for j = 1:length(depth_real)
        [~, ix] = min(abs(x_pinn - depth_real(j)));
        T_pinn_profile(j) = T_pinn(ix, idx_pinn);
    end

    c = colors(i,:);

    % Measured
    plot(depth_real, T_real_profile, 'o', ...
        'Color', c, ...
        'LineWidth', 1.2, ...
        'MarkerSize', 5, ...
        'DisplayName', sprintf('Measured, %.1f year', t0));

    % FDM
    plot(depth_real, T_fdm_profile, 's--', ...
        'Color', c, ...
        'LineWidth', 1.5, ...
        'MarkerSize', 5, ...
        'DisplayName', sprintf('FDM, %.1f year', t0));

    % PINNs
    plot(depth_real, T_pinn_profile, '-', ...
        'Color', c, ...
        'LineWidth', 1.5, ...
        'MarkerSize', 5, ...
        'DisplayName', sprintf('PINNs, %.1f year', t0));
end

% 坐标轴设置
xlim([min(depth_real) max(depth_real)]);
ylim([ymin ymax]);

xticks(depth_real);
xtickformat('%.1f');
ytickformat('%.1f');

xlabel('Depth (m)');
ylabel('T (^{\circ}C)');

grid on;
ax.GridAlpha = 0.2;
ax.LineWidth = 0.8;
ax.FontSize = 10;

% 图例放到底部
lgd = legend('Location','southoutside', ...
    'Orientation','horizontal', ...
    'Box','off');