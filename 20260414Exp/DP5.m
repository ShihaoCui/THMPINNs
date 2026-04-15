clear all;
clc;
close all;

load('DATASUB.mat')

% 插值到每10天的时刻

t_sub = t_sub-t_sub(:,1);

% 作图
figure
hold on
t_sub = t_sub;

plot(t_sub, Data_sub(:,1), '-')
plot(t_sub, Data_sub(:,2), '-')
plot(t_sub, Data_sub(:,3), '-')
plot(t_sub, Data_sub(:,4), '-')
plot(t_sub, Data_sub(:,5), '-')


legend("4m","5m","6m","7m","8m")
xlabel('Time (year)')
ylabel('Temperature (°C)')

signal1 = Data_sub(:,1);



t = t_sub(:);
y = signal1(:);

% -------- 拟合 signal1 = A*sin(2*pi*t + phi) + C --------
model = @(p,t) p(1)*sin(2*pi*t + p(2)) + p(3);   % p=[A, phi, C]

% 初值
A0 = (max(y)-min(y))/2;
phi0 = 0;
C0 = -7;
p0 = [A0, phi0, C0];

obj = @(p) sum((y - model(p,t)).^2);
p_fit = fminsearch(obj, p0);

A_fit   = p_fit(1);
phi_fit = p_fit(2);
C_fit   = p_fit(3);

y_fit = model(p_fit, t);

fprintf('Fitted amplitude A = %.4f\n', A_fit);
fprintf('Fitted phase phi   = %.4f rad\n', phi_fit);
fprintf('Fitted offset C    = %.4f\n', C_fit);

figure
plot(t, y, 'b.', 'DisplayName', 'signal1')
hold on
plot(t, y_fit, 'r-', 'LineWidth', 2, 'DisplayName', 'Fitted sine')
xlabel('Time (year)')
ylabel('Temperature (°C)')
legend
grid on
title('Sine fitting with free offset')