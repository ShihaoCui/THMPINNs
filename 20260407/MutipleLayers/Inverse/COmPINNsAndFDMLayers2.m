clear; clc; close all;

%% =========================
% Load MAT files
%% =========================
fdm = load('fdm_three_layer_cascade_result.mat');
L2  = load('inverse_pinn_1_2m_result.mat');

%% =========================
% FDM variables
%% =========================
x_fdm = fdm.x(:);
t_fdm = fdm.t(:);
T_fdm = fdm.T_cascade;

%% =========================
% PINN variables (Layer 2: 1-2 m)
%% =========================
x_pinn = L2.x_actual_pinn(:);
t_pinn = L2.t_pinn(:);
T_pinn = double(L2.T_field_pinn);

%% =========================
% Extract FDM second layer: 1-2 m
%% =========================
idx_layer2 = (x_fdm >= 1.0) & (x_fdm <= 2.0);
x_fdm_L2 = x_fdm(idx_layer2);
T_fdm_L2 = T_fdm(idx_layer2, :);

%% =========================
% Interpolate FDM to PINN time grid if needed
%% =========================
if length(t_fdm) ~= length(t_pinn) || max(abs(t_fdm - t_pinn)) > 1e-10
    T_fdm_L2_t = zeros(length(x_fdm_L2), length(t_pinn));
    for i = 1:length(x_fdm_L2)
        T_fdm_L2_t(i, :) = interp1(t_fdm, T_fdm_L2(i, :), t_pinn, 'linear');
    end
else
    T_fdm_L2_t = T_fdm_L2;
end

%% =========================
% Interpolate FDM to PINN spatial grid if needed
%% =========================
if length(x_fdm_L2) ~= length(x_pinn) || max(abs(x_fdm_L2 - x_pinn)) > 1e-10
    T_fdm_on_pinn = zeros(length(x_pinn), length(t_pinn));
    for j = 1:length(t_pinn)
        T_fdm_on_pinn(:, j) = interp1(x_fdm_L2, T_fdm_L2_t(:, j), x_pinn, 'linear');
    end
else
    T_fdm_on_pinn = T_fdm_L2_t;
end

%% =========================
% Error field
%% =========================
Err = T_pinn - T_fdm_on_pinn;
mae_layer2  = mean(abs(Err(:)));
rmse_layer2 = sqrt(mean(Err(:).^2));
maxerr_layer2 = max(abs(Err(:)));

fprintf('\nLayer 2 comparison:\n');
fprintf('MAE    = %.8f\n', mae_layer2);
fprintf('RMSE   = %.8f\n', rmse_layer2);
fprintf('MaxAbs = %.8f\n', maxerr_layer2);

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
title('(a2)');
colormap(gca, bwr);
cb3 = colorbar;
cb3.Label.String = 'T FDM (°C)';


subplot(1,3,2)
imagesc(t_pinn, x_pinn, T_pinn);
set(gca,'YDir','reverse');
xlabel('Time (days)');
ylabel('Depth (m)');
title('(b2)');
colormap(gca, bwr);
cb3 = colorbar;
cb3.Label.String = 'T PINNs (°C)';


subplot(1,3,3)
imagesc(t_pinn, x_pinn, Err);
set(gca,'YDir','reverse');
xlabel('Time (days)');
ylabel('Depth (m)');
title('(c2)');
colormap(gca, bwr);
cb3 = colorbar;
cb3.Label.String = 'T difference (°C)';

% sgtitle(sprintf('Layer 2 temperature field comparison (MAE = %.4e)', mae_layer2));