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


depth = [4,5,6,7,8];
figure
hold on
plot(depth,Data_sub(1,:))
scatter(depth,Data_sub(1,:))
xlabel('Depth (m)')
ylabel('Temperature (°C)')



T0 = Data_sub(1,:);   % 初始时刻各深度温度

% 生成更密的深度点
depth_fine = 4:0.1:8;

% 线性插值
T0_fine = interp1(depth, T0, depth_fine, 'spline');

figure
hold on
scatter(depth, T0,"ro")
plot(depth_fine, T0_fine, '-')
scatter(depth_fine, T0_fine, 20, 'filled')

xlabel('Depth (m)')
ylabel('Temperature (°C)')
legend('Original data','Interpolated curve','Interpolated points')