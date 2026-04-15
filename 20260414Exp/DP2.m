clear all;
clc;
close all;

load('ExpData_2hours_Inteval_Interp.mat')
DataSelected = ExpData_2hours_Inteval_Interp(:,4:8);

% 提取 t 从 2.55 年到 2.85 年的数据
idx = (t >= 7.2) & (t <= 7.8);

t_sub = t(idx);
Data_sub = DataSelected(idx,:);

figure
hold on
% plot(t_sub, Data_sub(:,1))
plot(t_sub, Data_sub(:,2))
plot(t_sub, Data_sub(:,3))
plot(t_sub, Data_sub(:,4))
plot(t_sub, Data_sub(:,5))
legend("5m","6m","7m","8m")
xlabel('Time (year)')
ylabel('Value')


