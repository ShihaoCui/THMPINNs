% close all;

%% =========================
% 图1：仅在 5/6/7 m 处画温度-时间对比
% 并显示 FDM 和 PINNs 相对实验数据的 MAE
% =========================
depth_list = [5 6 7];

figure('Position',[120 80 900 560]);
tl = tiledlayout(3,1,'TileSpacing','compact','Padding','compact');

for i = 1:length(depth_list)
    x0 = depth_list(i);

    % 实验数据在 Data_real 中对应列
    % depth_real = [4 5 6 7 8]
    idx_real_col = find(depth_real == x0);

    % FDM / PINNs 对应深度索引
    [~, idx_fdm]  = min(abs(x_fdm - x0));
    [~, idx_pinn] = min(abs(x_pinn - x0));

    % 当前深度的数据
    T_meas_i = Data_real(:, idx_real_col);
    T_fdm_i  = T_fdm(idx_fdm, :);
    T_pinn_i = T_pinn(idx_pinn, :);

    % ===== 计算 MAE：用实验时刻作为比较基准 =====
    % 只在共同时间范围内比较
    mask_fdm = (t_real >= min(t_fdm_year)) & (t_real <= max(t_fdm_year));
    mask_pinn = (t_real >= min(t_pinn_year)) & (t_real <= max(t_pinn_year));

    % 将 FDM / PINNs 插值到实验时间点
    T_fdm_interp  = interp1(t_fdm_year,  T_fdm_i,  t_real(mask_fdm),  'linear');
    T_pinn_interp = interp1(t_pinn_year, T_pinn_i, t_real(mask_pinn), 'linear');

    % 对应实验值
    T_meas_fdm  = T_meas_i(mask_fdm);
    T_meas_pinn = T_meas_i(mask_pinn);

    % MAE
    mae_fdm  = mean(abs(T_fdm_interp(:)  - T_meas_fdm(:)));
    mae_pinn = mean(abs(T_pinn_interp(:) - T_meas_pinn(:)));

    % ===== 当前子图 =====
    ax = nexttile;
    hold(ax,'on'); 
    box(ax,'on');

    % 实验
    p1 = plot(t_real, T_meas_i, 'ko', ...
        'MarkerSize', 4, ...
        'LineWidth', 0.8, ...
        'DisplayName', 'Measured');

    % FDM
    p2 = plot(t_fdm_year, T_fdm_i, 'b-', ...
        'LineWidth', 1.6, ...
        'DisplayName', 'FDM');

    % PINNs
    p3 = plot(t_pinn_year, T_pinn_i, 'r--', ...
        'LineWidth', 1.6, ...
        'DisplayName', 'PINNs');

    % ===== 坐标范围 =====
    local_all = [T_meas_i(:); T_fdm_i(:); T_pinn_i(:)];
    local_min = min(local_all);
    local_max = max(local_all);
    yrange = local_max - local_min;
    if yrange == 0
        yrange = 1;
    end
    pad = 0.4 * yrange;

    xmin = min([t_real; t_fdm_year; t_pinn_year]);
    xmax = max([t_real; t_fdm_year; t_pinn_year]);

    xlim([xmin, xmax]);
    ylim([local_min - pad, local_max + pad]);

    % ===== x 轴间隔设为 0.1 =====
    xticks(ax, xmin:0.1:xmax);
    xtickformat(ax, '%.1f');

    % ===== y 轴保留 1 位小数，例如 7.0 =====
    ytickformat(ax, '%.1f');

    % 左上角标注深度
    text(0.02, 0.88, sprintf('%d m', x0), ...
        'Units','normalized', ...
        'FontSize',11);

    % 右上角标注 MAE
    txt = sprintf('MAE(FDM) = %.3f ^oC\nMAE(PINNs) = %.3f ^oC', mae_fdm, mae_pinn);
    text(0.70, 0.78, txt, ...
        'Units','normalized', ...
        'FontSize',8, ...
        'BackgroundColor','white', ...
        'EdgeColor',[0.7 0.7 0.7], ...
        'Margin',5);

    ylabel('T (^{\circ}C)');
    grid off;
    ax.GridAlpha = 0.2;
    ax.LineWidth = 0.8;
    ax.FontSize = 10;

    if i ~= length(depth_list)
        ax.XTickLabel = [];
    else
        xlabel('Time (year)');
    end
end

% 总图例（放在图片底部）
lgd = legend([p1,p2,p3], {'Measured','FDM','PINNs'}, ...
    'Orientation','horizontal', ...
    'Location','southoutside', ...
    'Box','off');
lgd.Layout.Tile = 'south';

% 可选总标题
title(tl, '(b)');