clear; clc; close all;

loss_data = readtable('loss_history.csv');

epoch = loss_data.epoch;
total_loss = loss_data.total;
pde_loss = loss_data.pde;
ic_loss = loss_data.ic;
bc_loss = loss_data.bc;
data_loss = loss_data.data;

idx = mod(epoch, 500) == 0 | epoch == 1;

epoch_s = epoch(idx);
total_s = total_loss(idx);
pde_s = pde_loss(idx);
ic_s = ic_loss(idx);
bc_s = bc_loss(idx);
data_s = data_loss(idx);

data_s(data_s <= 0) = NaN;

figure('Position', [100, 100, 900, 550]);

plot(epoch_s, total_s, '-o', 'LineWidth', 1.8, 'MarkerSize', 5); hold on;
plot(epoch_s, pde_s,   '-s', 'LineWidth', 1.5, 'MarkerSize', 5);
plot(epoch_s, ic_s,    '-^', 'LineWidth', 1.5, 'MarkerSize', 5);
plot(epoch_s, bc_s,    '-d', 'LineWidth', 1.5, 'MarkerSize', 5);
plot(epoch_s, data_s,  '-x', 'LineWidth', 1.5, 'MarkerSize', 6);

set(gca, 'YScale', 'log');
xlabel('Epoch');
ylabel('Loss $\mathcal{L}$', 'Interpreter', 'latex');
% title('Training Loss History', 'Interpreter', 'latex');

legend({'$\mathcal{L}$', '$\mathcal{L}_{P}$', '$\mathcal{L}_{I}$', '$\mathcal{L}_{B}$'}, ...
    'Interpreter', 'latex', 'Location', 'best');

% grid on;
% box on;