clear; clc; close all;

%% =========================
% Load MAT files
%% =========================
fdm = load('fdm_three_layer_cascade_result.mat');
L1  = load('inverse_pinn_0_1m_result.mat');

%% =========================
% FDM variables
%% =========================
x_fdm = fdm.x(:);
t_fdm = fdm.t(:);
T_fdm = fdm.T_cascade;

%% =========================
% PINN variables (Layer 1: 0-1 m)
%% =========================
x_pinn = L1.x_pinn(:);
t_pinn = L1.t_pinn(:);
T_pinn = double(L1.T_field_pinn);

%% =========================
% Extract FDM first layer: 0-1 m
%% =========================
idx_layer1 = (x_fdm >= 0) & (x_fdm <= 1.0);
x_fdm_L1 = x_fdm(idx_layer1);
T_fdm_L1 = T_fdm(idx_layer1, :);

%% =========================
% Interpolate FDM to PINN time grid if needed
%% =========================
if length(t_fdm) ~= length(t_pinn) || max(abs(t_fdm - t_pinn)) > 1e-10
    T_fdm_L1_t = zeros(length(x_fdm_L1), length(t_pinn));
    for i = 1:length(x_fdm_L1)
        T_fdm_L1_t(i, :) = interp1(t_fdm, T_fdm_L1(i, :), t_pinn, 'linear');
    end
else
    T_fdm_L1_t = T_fdm_L1;
end

%% =========================
% Interpolate FDM to PINN spatial grid if needed
%% =========================
if length(x_fdm_L1) ~= length(x_pinn) || max(abs(x_fdm_L1 - x_pinn)) > 1e-10
    T_fdm_on_pinn = zeros(length(x_pinn), length(t_pinn));
    for j = 1:length(t_pinn)
        T_fdm_on_pinn(:, j) = interp1(x_fdm_L1, T_fdm_L1_t(:, j), x_pinn, 'linear');
    end
else
    T_fdm_on_pinn = T_fdm_L1_t;
end

%% =========================
% Error field
%% =========================
Err = T_pinn - T_fdm_on_pinn;
mae_layer1  = mean(abs(Err(:)));
rmse_layer1 = sqrt(mean(Err(:).^2));
maxerr_layer1 = max(abs(Err(:)));

fprintf('\nLayer 1 comparison:\n');
fprintf('MAE    = %.8f\n', mae_layer1);
fprintf('RMSE   = %.8f\n', rmse_layer1);
fprintf('MaxAbs = %.8f\n', maxerr_layer1);

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
imagesc(t_pinn, x_pinn, T_fdm_on_pinn);
set(gca,'YDir','reverse');
xlabel('Time (days)');
ylabel('Depth (m)');
title('(a1)');
colormap(gca, bwr);
cb3 = colorbar;
cb3.Label.String = 'T FDM (°C)';

subplot(1,3,2)
imagesc(t_pinn, x_pinn, T_pinn);
set(gca,'YDir','reverse');
xlabel('Time (days)');
ylabel('Depth (m)');
title('(b1)');
colormap(gca, bwr);
cb3 = colorbar;
cb3.Label.String = 'T PINNs (°C)';

subplot(1,3,3)
imagesc(t_pinn, x_pinn, Err);
set(gca,'YDir','reverse');
xlabel('Time (days)');
ylabel('Depth (m)');
title('(c1)');
colormap(gca, bwr);
cb3 = colorbar;
cb3.Label.String = 'T difference (°C)';

% sgtitle(sprintf('Layer 1 temperature field comparison (MAE = %.4e)', mae_layer1));