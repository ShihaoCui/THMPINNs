clear; clc; close all;

%% =========================
% 1. 读取三类数据
% =========================
realData = load('DATASUB.mat');
fdmData  = load('fdm_field_4_8m_eval.mat');
pinnData = load('field_pinn_4_8m_day_based_result.mat');

% ---------- 实际数据 ----------
t_real = realData.t_sub(:);          
Data_real = realData.Data_sub;       
t_real = t_real - t_real(1);         
depth_real = [4 5 6 7 8];

% ---------- FDM ----------
x_fdm      = fdmData.x_fdm(:);
t_fdm_year = fdmData.t_fdm_year(:);
T_fdm      = fdmData.T_field_fdm;

% ---------- PINNs ----------
x_pinn      = pinnData.x_pinn(:);
t_pinn_year = pinnData.t_pinn_year(:);
T_pinn      = pinnData.T_field_pinn;

%% =========================
% 2. 统一温度场矩阵方向为 [Nx, Nt]
% =========================
if size(T_fdm,1) == length(t_fdm_year) && size(T_fdm,2) == length(x_fdm)
    T_fdm = T_fdm';
end

if size(T_pinn,1) == length(t_pinn_year) && size(T_pinn,2) == length(x_pinn)
    T_pinn = T_pinn';
end

assert(size(T_fdm,1) == length(x_fdm), 'FDM: 第一维应为深度 x');
assert(size(T_fdm,2) == length(t_fdm_year), 'FDM: 第二维应为时间 t');
assert(size(T_pinn,1) == length(x_pinn), 'PINNs: 第一维应为深度 x');
assert(size(T_pinn,2) == length(t_pinn_year), 'PINNs: 第二维应为时间 t');

%% =========================
% 3. 图1：4/5/6/7/8 m 处三者温度-时间对比
% =========================
depth_list = [4 5 6 7 8];

figure('Position',[100 80 1000 720]);
tiledlayout(5,1,'TileSpacing','compact','Padding','compact');

for i = 1:length(depth_list)
    x0 = depth_list(i);

    [~, idx_fdm]  = min(abs(x_fdm - x0));
    [~, idx_pinn] = min(abs(x_pinn - x0));

    nexttile;
    hold on; box on;

    plot(t_real, Data_real(:,i), 'ko', ...
        'MarkerSize', 4, 'DisplayName', 'Measured');

    plot(t_fdm_year, T_fdm(idx_fdm,:), 'b-', ...
        'LineWidth', 1.8, 'DisplayName', 'FDM');

    plot(t_pinn_year, T_pinn(idx_pinn,:), 'r--', ...
        'LineWidth', 1.8, 'DisplayName', 'PINNs');

    ylabel('T (^oC)');
    title(sprintf('Depth = %d m', x0));
    grid on;
    set(gca,'FontSize',10);

    if i == 1
        legend('Location','best');
    end
    
    if i == length(depth_list)
        xlabel('Time (year)');
    end
end




%% =========================
% 4. 图2：选定年份下三者温度-深度对比
% =========================
time_list = [0 0.1 0.2 0.3 0.4 0.5 0.6];

figure('Position',[120 80 1100 720]);
tiledlayout(7,1,'TileSpacing','compact','Padding','compact');

for i = 1:length(time_list)
    t0 = time_list(i);

    [~, idx_real] = min(abs(t_real - t0));
    [~, idx_fdm]  = min(abs(t_fdm_year - t0));
    [~, idx_pinn] = min(abs(t_pinn_year - t0));

    nexttile;
    hold on; box on;

    plot(depth_real, Data_real(idx_real,:), 'ko-', ...
        'LineWidth', 1.2, 'MarkerSize', 4, 'DisplayName', 'Measured');

    T_fdm_profile = zeros(size(depth_real));
    for j = 1:length(depth_real)
        [~, ix] = min(abs(x_fdm - depth_real(j)));
        T_fdm_profile(j) = T_fdm(ix, idx_fdm);
    end
    plot(depth_real, T_fdm_profile, 'b-s', ...
        'LineWidth', 1.6, 'MarkerSize', 4, 'DisplayName', 'FDM');

    T_pinn_profile = zeros(size(depth_real));
    for j = 1:length(depth_real)
        [~, ix] = min(abs(x_pinn - depth_real(j)));
        T_pinn_profile(j) = T_pinn(ix, idx_pinn);
    end
    plot(depth_real, T_pinn_profile, 'r--d', ...
        'LineWidth', 1.6, 'MarkerSize', 4, 'DisplayName', 'PINNs');

    ylabel('T (^oC)');
    title(sprintf('t = %.1f year', t0));
    grid on;
    set(gca,'FontSize',10);

    if i == 1
        legend('Location','best');
    end
    
    if i == length(time_list)
        xlabel('Depth (m)');
    end
end

sgtitle('Temperature-depth comparison at selected times','FontSize',13);





%% =========================
% 5. 整体温度场对比图
% =========================
figure('Position',[150 100 1200 400]);

subplot(1,2,1)
imagesc(t_fdm_year, x_fdm, T_fdm);
set(gca,'YDir','normal');
xlabel('Time (year)');
ylabel('Depth (m)');
title('FDM temperature field');
colorbar;
grid on;

subplot(1,2,2)
imagesc(t_pinn_year, x_pinn, T_pinn);
set(gca,'YDir','normal');
xlabel('Time (year)');
ylabel('Depth (m)');
title('PINNs temperature field');
colorbar;
grid on;