close all;

figure;

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
tl = tiledlayout(2,3,'TileSpacing','compact','Padding','compact');

imagesc(t_pinn_year, x_pinn, T_pinn);
set(gca, 'YDir', 'reverse');
colormap(gca, bwr);
% caxis([temp_min temp_max]);
xlabel('Time (year)');
ylabel('Depth (m)');
title(tl,'(b)');
cb2 = colorbar;
cb2.Label.String = 'PINNs T (°C)';
grid on;
