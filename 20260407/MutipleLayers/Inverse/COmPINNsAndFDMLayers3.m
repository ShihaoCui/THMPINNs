clear; clc; close all;

%% =========================
% Load MAT files
%% =========================
fdm = load('fdm_three_layer_cascade_result.mat');
L3  = load('inverse_pinn_2_5m_result.mat');

%% =========================
% FDM variables
%% =========================
x_fdm = fdm.x(:);
t_fdm = fdm.t(:);
T_fdm = fdm.T_cascade;

%% =========================
% PINN variables (Layer 3: 2-5 m)
%% =========================
x_local_pinn  = L3.x_local_pinn(:);   % local coordinate: 0-3 m
x_actual_pinn = L3.x_actual_pinn(:);  % actual depth: 2-5 m
t_pinn        = L3.t_pinn(:);
T_pinn        = double(L3.T_field_pinn);

%% =========================
% Extract FDM third layer: 2-5 m
%% =========================
idx_layer3 = (x_fdm >= 2.0) & (x_fdm <= 5.0);
x_fdm_L3 = x_fdm(idx_layer3);
T_fdm_L3 = T_fdm(idx_layer3, :);

%% =========================
% Interpolate FDM to PINN time grid if needed
%% =========================
if length(t_fdm) ~= length(t_pinn) || max(abs(t_fdm - t_pinn)) > 1e-10
    T_fdm_L3_t = zeros(length(x_fdm_L3), length(t_pinn));
    for i = 1:length(x_fdm_L3)
        T_fdm_L3_t(i, :) = interp1(t_fdm, T_fdm_L3(i, :), t_pinn, 'linear');
    end
else
    T_fdm_L3_t = T_fdm_L3;
end

%% =========================
% Interpolate FDM to PINN spatial grid if needed
%% =========================
if length(x_fdm_L3) ~= length(x_actual_pinn) || max(abs(x_fdm_L3 - x_actual_pinn)) > 1e-10
    T_fdm_on_pinn = zeros(length(x_actual_pinn), length(t_pinn));
    for j = 1:length(t_pinn)
        T_fdm_on_pinn(:, j) = interp1(x_fdm_L3, T_fdm_L3_t(:, j), x_actual_pinn, 'linear');
    end
else
    T_fdm_on_pinn = T_fdm_L3_t;
end

%% =========================
% Error field
%% =========================
Err = T_pinn - T_fdm_on_pinn;
mae_layer3  = mean(abs(Err(:)));
rmse_layer3 = sqrt(mean(Err(:).^2));
maxerr_layer3 = max(abs(Err(:)));

fprintf('\nLayer 3 comparison:\n');
fprintf('MAE    = %.8f\n', mae_layer3);
fprintf('RMSE   = %.8f\n', rmse_layer3);
fprintf('MaxAbs = %.8f\n', maxerr_layer3);

%% =========================
% Custom bwr colormap
%% =========================
n = 256;
bottom = [0 0 1];
middle = [1 1 1];
top = [1 0 0];

r = [linspace(bottom(1), middle(1), n/2), linspace(middle(1), top(1), n/2)]';
g = [linspace(bottom(2), middle(2), n/2), linspace(middle(2), top(2), n/2)]';
b = [linspace(bottom(3), middle(3), n/2), linspace(middle(3), top(3), n/2)]';
bwr = [r g b];

%% =========================
% Only Figure 1: Temperature field comparison
%% =========================
figure('Color','w','Position',[100 100 1500 420]);

subplot(1,3,1)
imagesc(t_pinn, x_actual_pinn, T_fdm_on_pinn);
set(gca,'YDir','reverse');
xlabel('Time (days)');
ylabel('Depth (m)');
title('(a3)');
colormap(gca, bwr);
cb3 = colorbar;
cb3.Label.String = 'T FDM (°C)';

subplot(1,3,2)
imagesc(t_pinn, x_actual_pinn, T_pinn);
set(gca,'YDir','reverse');
xlabel('Time (days)');
ylabel('Depth (m)');
title('(b3)');
colormap(gca, bwr);
cb3 = colorbar;
cb3.Label.String = 'T PINNs (°C)';

subplot(1,3,3)
imagesc(t_pinn, x_actual_pinn, Err);
set(gca,'YDir','reverse');
xlabel('Time (days)');
ylabel('Depth (m)');
title('(c3)');
colormap(gca, bwr);
cb3 = colorbar;
cb3.Label.String = 'T difference (°C)';

% sgtitle(sprintf('Layer 3 temperature field comparison (MAE = %.4e)', mae_layer3));