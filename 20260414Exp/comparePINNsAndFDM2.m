%% =========================
% 图2：选定年份下三者温度-深度对比
% 改成 2 行 3 列
% =========================
time_list = [0 0.1 0.2 0.3 0.4 0.5];

% 统一纵轴范围
allT = [Data_real(:); T_fdm(:); T_pinn(:)];
ymin = floor(min(allT));
ymax = ceil(max(allT));

figure('Position',[120 80 1100 650]);
tl = tiledlayout(2,3,'TileSpacing','compact','Padding','compact');

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

    ax = nexttile;
    hold(ax,'on');
    box(ax,'on');

    % 三类曲线
    p1 = plot(depth_real, T_real_profile, 'ko-', ...
        'LineWidth', 1.0, 'MarkerSize', 4, 'DisplayName', 'Measured');

    p2 = plot(depth_real, T_fdm_profile, 'b-s', ...
        'LineWidth', 1.5, 'MarkerSize', 4, 'DisplayName', 'FDM');

    p3 = plot(depth_real, T_pinn_profile, 'r--d', ...
        'LineWidth', 1.5, 'MarkerSize', 4, 'DisplayName', 'PINNs');

    % 坐标范围统一
    xlim([min(depth_real) max(depth_real)]);
    ylim([ymin ymax]);

    % x 轴刻度
    xticks(depth_real);
    xtickformat('%.1f');

    % y 轴一位小数
    ytickformat('%.1f');

    % 小标签代替标题
    text(0.02, 0.88, sprintf('%.1f year', t0), ...
        'Units','normalized', ...
        'FontSize',11);

    % 仅左侧子图显示 y 标签
    if ismember(i, [1 4])
        ylabel('T (^{\circ}C)');
    else
        ax.YTickLabel = [];
    end

    % 仅底部一排显示 x 标签
    if i > 3
        xlabel('Depth (m)');
    else
        ax.XTickLabel = [];
    end

    grid on;
    ax.GridAlpha = 0.2;
    ax.LineWidth = 0.8;
    ax.FontSize = 10;
end

% 总图例（放在图片底部）
lgd = legend([p1,p2,p3], {'Measured','FDM','PINNs'}, ...
    'Orientation','horizontal', ...
    'Location','southoutside', ...
    'Box','off');
lgd.Layout.Tile = 'south';

% 可选总标题
title(tl, '(a)');