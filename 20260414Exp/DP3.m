clear all;
clc;
close all;

load('ExpData_2hours_Inteval_Interp.mat')
DataSelected = ExpData_2hours_Inteval_Interp(:,4:8);

% 提取 2.55 年到 2.85 年
idx = (t >= 7.1) & (t <= 7.6);
t_sub = t(idx);
Data_sub = DataSelected(idx,:);
% save DATASUB Data_sub t_sub
% 每10天采样一次
dt_sample = 8/365;   % 10 days in year unit
t_sample = t_sub(1):dt_sample:t_sub(end);

% 插值到每10天的时刻
Data_sample = zeros(length(t_sample), size(Data_sub,2));
for i = 1:size(Data_sub,2)
    Data_sample(:,i) = interp1(t_sub, Data_sub(:,i), t_sample, 'linear');
end

% 作图
figure
hold on

plot(t_sub, Data_sub(:,1), '-')
plot(t_sub, Data_sub(:,2), '-')
plot(t_sub, Data_sub(:,3), '-')
plot(t_sub, Data_sub(:,4), '-')
plot(t_sub, Data_sub(:,5), '-')

scatter(t_sample, Data_sample(:,1), 25, 'filled')
scatter(t_sample, Data_sample(:,2), 25, 'filled')
scatter(t_sample, Data_sample(:,3), 25, 'filled')
scatter(t_sample, Data_sample(:,4), 25, 'filled')
scatter(t_sample, Data_sample(:,5), 25, 'filled')

legend("4m","5m","6m","7m","8m")
xlabel('Time (year)')
ylabel('Value')