close all;

%% =========================
% 图：边界上 PINNs 与实验数据的温度-时间对比
% 仅画 4 m 和 8 m，不画 FDM
% 并在每个子图中直接显示 MAE(PINNs, Measured)
% =========================

% 需要这些变量已存在于工作区：
% depth_real = [4 5 6 7 8];
% t_real
% Data_real
% x_pinn
% t_pinn_year
% T_pinn

boundary_list = [4 8];

figure('Position',[140 100 900 420]);
tl = tiledlayout(2,1,'TileSpacing','compact','Padding','compact');

for i = 1:length(boundary_list)
    x0 = boundary_list(i);

    % 实验数据列索引
    idx_real_col = find(depth_real == x0);

    % PINNs 深度索引
    [~, idx_pinn] = min(abs(x_pinn - x0));

    % 当前边界的数据
    T_meas_i = Data_real(:, idx_real_col);
    T_pinn_i = T_pinn(idx_pinn, :);

    % ===== 计算 MAE：将 PINNs 插值到实验时间点 =====
    mask_pinn = (t_real >= min(t_pinn_year)) & (t_real <= max(t_pinn_year));

    T_pinn_interp = interp1(t_pinn_year, T_pinn_i, t_real(mask_pinn), 'linear');
    T_meas_common = T_meas_i(mask_pinn);

    mae_pinn = mean(abs(T_pinn_interp(:) - T_meas_common(:)));

    % ===== 当前子图 =====
    ax = nexttile;
    hold(ax, 'on');
    box(ax, 'on');

    % 实验数据
    p1 = plot(t_real, T_meas_i, 'ko', ...
        'MarkerSize', 4, ...
        'LineWidth', 0.8, ...
        'DisplayName', 'Measured');

    % PINNs
    p2 = plot(t_pinn_year, T_pinn_i, 'r--', ...
        'LineWidth', 1.8, ...
        'DisplayName', 'PINNs');

    % ===== 坐标范围 =====
    local_all = [T_meas_i(:); T_pinn_i(:)];
    local_min = min(local_all);
    local_max = max(local_all);
    yrange = local_max - local_min;
    if yrange == 0
        yrange = 1;
    end
    pad = 0.6 * yrange;

    xmin = min([t_real; t_pinn_year]);
    xmax = max([t_real; t_pinn_year]);

    xlim([xmin, xmax]);
    xticks(ax, xmin:0.1:xmax);
    xtickformat(ax, '%.1f');

    ylim([local_min - pad, local_max + pad]);
    ytickformat(ax, '%.1f');

    % ===== 左上角标注：深度 + MAE =====
    text(0.02, 0.82, sprintf('%d m: MAE = %.3f ^oC', x0, mae_pinn), ...
        'Units', 'normalized', ...
        'FontSize', 11);

    % ===== 坐标轴样式 =====
    ylabel('T (^{\circ}C)');
    grid(ax, 'off');
    ax.LineWidth = 0.8;
    ax.FontSize = 10;

    if i ~= length(boundary_list)
        ax.XTickLabel = [];
    else
        xlabel('Time (year)');
    end
end

% ===== 总图例（放到底部）=====
lgd = legend([p1, p2], {'Measured', 'PINNs'}, ...
    'Orientation', 'horizontal', ...
    'Location', 'southoutside', ...
    'Box', 'off');
lgd.Layout.Tile = 'south';

% 可选总标题
title(tl, '(a)');