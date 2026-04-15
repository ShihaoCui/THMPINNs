clear all;
clc;
close all;

load('ExpData_2hours_Inteval_Interp.mat')
DataSelected = ExpData_2hours_Inteval_Interp(:,4:8);

figure
hold on
plot(t,DataSelected(:,1))
plot(t,DataSelected(:,2))
plot(t,DataSelected(:,3))
plot(t,DataSelected(:,4))
plot(t,DataSelected(:,5))
legend("4m","5m","6m","7m","8m")
