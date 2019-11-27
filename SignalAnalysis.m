% This file is used to analyze signals of sensors (four sensors: COM5, COM6, COM7, COM8; two channels: Ch0, Ch1)
% and check the correlation and cross-correlation of eight signals
% Input: Signal data
% Output: Correlation and cross-correlation of eight signals

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear;
clc;
close all;

%% Load Data

load('D:/Philips/Database/Human/20160831_163913_walking_in_the_room_without_fan/COM5_walking_in_the_room_without_fan_20160831_163913.mat');
% Data table: Hour (the first column), ... , Ch0 (the forth column), ...
Data = table2array(Data);
COM5Hour = Data(:,1);
COM5Minute = Data(:,2);
COM5Second = Data(:,3);
COM5Ch0 = Data(:,4);
COM5Ch1 = Data(:,5);
COM5Temp = Data(:,6);
COM5Det = Data(:,7);
COM5OldDet = Data(:,8);
COM5STime = COM5Hour*3600+COM5Minute*60+floor(COM5Second);

load('D:/Philips/Database/Human/20160831_163913_walking_in_the_room_without_fan/COM6_walking_in_the_room_without_fan_20160831_163913.mat');
Data = table2array(Data);
COM6Hour = Data(:,1);
COM6Minute = Data(:,2);
COM6Second = Data(:,3);
COM6Ch0 = Data(:,4);
COM6Ch1 = Data(:,5);
COM6Temp = Data(:,6);
COM6Det = Data(:,7);
COM6OldDet = Data(:,8);
COM6STime = COM6Hour*3600+COM6Minute*60+floor(COM6Second);

load('D:/Philips/Database/Human/20160831_163913_walking_in_the_room_without_fan/COM7_walking_in_the_room_without_fan_20160831_163913.mat');
Data = table2array(Data);
COM7Hour = Data(:,1);
COM7Minute = Data(:,2);
COM7Second = Data(:,3);
COM7Ch0 = Data(:,4);
COM7Ch1 = Data(:,5);
COM7Temp = Data(:,6);
COM7Det = Data(:,7);
COM7OldDet = Data(:,8);
COM7STime = COM7Hour*3600+COM7Minute*60+floor(COM7Second);

load('D:/Philips/Database/Human/20160831_163913_walking_in_the_room_without_fan/COM8_walking_in_the_room_without_fan_20160831_163913.mat');
Data = table2array(Data);
COM8Hour = Data(:,1);
COM8Minute = Data(:,2);
COM8Second = Data(:,3);
COM8Ch0 = Data(:,4);
COM8Ch1 = Data(:,5);
COM8Temp = Data(:,6);
COM8Det = Data(:,7);
COM8OldDet = Data(:,8);
COM8STime = COM8Hour*3600+COM8Minute*60+floor(COM8Second);

%% Align Time

TimeStart = max([COM5STime(1), COM6STime(1), COM7STime(1), COM8STime(1)]);
TimeEnd = min([COM5STime(end), COM6STime(end), COM7STime(end), COM8STime(end)]);
COM5SignalLabelStart = find(COM5STime == TimeStart, 1);
COM5SignalLabelEnd = find(COM5STime == TimeEnd, 1, 'last');
COM6SignalLabelStart = find(COM6STime == TimeStart, 1);
COM6SignalLabelEnd = find(COM6STime == TimeEnd, 1, 'last');
COM7SignalLabelStart = find(COM7STime == TimeStart, 1);
COM7SignalLabelEnd = find(COM7STime == TimeEnd, 1, 'last');
COM8SignalLabelStart = find(COM8STime == TimeStart, 1);
COM8SignalLabelEnd = find(COM8STime == TimeEnd, 1, 'last');

Com5ch0 = COM5Ch0(COM5SignalLabelStart:COM5SignalLabelEnd);
Com5ch1 = COM5Ch1(COM5SignalLabelStart:COM5SignalLabelEnd);
Com5ReadingTime = COM5Hour(COM5SignalLabelStart:COM5SignalLabelEnd)*3600+COM5Minute(COM5SignalLabelStart:COM5SignalLabelEnd)*60+COM5Second(COM5SignalLabelStart:COM5SignalLabelEnd);
COM5Time = Com5ReadingTime-Com5ReadingTime(1);
Com6ch0 = COM6Ch0(COM6SignalLabelStart:COM6SignalLabelEnd);
Com6ch1 = COM6Ch1(COM6SignalLabelStart:COM6SignalLabelEnd);
Com6ReadingTime = COM6Hour(COM6SignalLabelStart:COM6SignalLabelEnd)*3600+COM6Minute(COM6SignalLabelStart:COM6SignalLabelEnd)*60+COM6Second(COM6SignalLabelStart:COM6SignalLabelEnd);
COM6Time = Com6ReadingTime-Com6ReadingTime(1);
Com7ch0 = COM7Ch0(COM7SignalLabelStart:COM7SignalLabelEnd);
Com7ch1 = COM7Ch1(COM7SignalLabelStart:COM7SignalLabelEnd);
Com7ReadingTime = COM7Hour(COM7SignalLabelStart:COM7SignalLabelEnd)*3600+COM7Minute(COM7SignalLabelStart:COM7SignalLabelEnd)*60+COM7Second(COM7SignalLabelStart:COM7SignalLabelEnd);
COM7Time = Com7ReadingTime-Com7ReadingTime(1);
Com8ch0 = COM8Ch0(COM8SignalLabelStart:COM8SignalLabelEnd);
Com8ch1 = COM8Ch1(COM8SignalLabelStart:COM8SignalLabelEnd);
Com8ReadingTime = COM8Hour(COM8SignalLabelStart:COM8SignalLabelEnd)*3600+COM8Minute(COM8SignalLabelStart:COM8SignalLabelEnd)*60+COM8Second(COM8SignalLabelStart:COM8SignalLabelEnd);
COM8Time = Com8ReadingTime-Com8ReadingTime(1);
maxDataPoint = min([length(Com5ch0),length(Com6ch0),length(Com7ch0),length(Com8ch0)]);

%% Plot Eight Signals

minSignal = min([min(Com5ch0),min(Com5ch1),min(Com6ch0),min(Com6ch1),min(Com7ch0),min(Com7ch1),min(Com8ch0),min(Com8ch1)]);
maxSignal = max([max(Com5ch0),max(Com5ch1),max(Com6ch0),max(Com6ch1),max(Com7ch0),max(Com7ch1),max(Com8ch0),max(Com8ch1)]);
maxTime = max([max(COM5Time),max(COM6Time),max(COM7Time),max(COM8Time)]);

figure;
subplot(4,2,1);
plot(COM5Time,Com5ch0);
axis([0 maxTime minSignal maxSignal]);
xlabel('time (second)');
ylabel('COM5Ch0');
subplot(4,2,2);
plot(COM5Time,Com5ch1);
axis([0 maxTime minSignal maxSignal]);
xlabel('time (second)');
ylabel('COM5Ch1');
subplot(4,2,3);
plot(COM6Time,Com6ch0);
axis([0 maxTime minSignal maxSignal]);
xlabel('time (second)');
ylabel('COM6Ch0');
subplot(4,2,4);
plot(COM6Time,Com6ch1);
axis([0 maxTime minSignal maxSignal]);
xlabel('time (second)');
ylabel('COM6Ch1');
subplot(4,2,5);
plot(COM7Time,Com7ch0);
axis([0 maxTime minSignal maxSignal]);
xlabel('time (second)');
ylabel('COM7Ch0');
subplot(4,2,6);
plot(COM7Time,Com7ch1);
axis([0 maxTime minSignal maxSignal]);
xlabel('time (second)');
ylabel('COM7Ch1');
subplot(4,2,7);
plot(COM8Time,Com8ch0);
axis([0 maxTime minSignal maxSignal]);
xlabel('time (second)');
ylabel('COM8Ch0');
subplot(4,2,8);
plot(COM8Time,Com8ch1);
axis([0 maxTime minSignal maxSignal]);
xlabel('time (second)');
ylabel('COM8Ch1');
suptitle('GeorgesWalkInOutWithoutFan');

%% Correlation of Signals

CorrCoefMatrix = corrcoef([Com5ch0(1:maxDataPoint),Com5ch1(1:maxDataPoint),...
    Com6ch0(1:maxDataPoint), Com6ch1(1:maxDataPoint),Com7ch0(1:maxDataPoint),...
    Com7ch1(1:maxDataPoint), Com8ch0(1:maxDataPoint),Com8ch1(1:maxDataPoint)]);

%% Cross-correlation of Signals

NormalizedCom5ch0 = (Com5ch0(1:maxDataPoint)-mean(Com5ch0(1:maxDataPoint)))./norm(Com5ch0(1:maxDataPoint)-mean(Com5ch0(1:maxDataPoint)));  % normalized signal
NormalizedCom5ch1 = (Com5ch1(1:maxDataPoint)-mean(Com5ch1(1:maxDataPoint)))./norm(Com5ch1(1:maxDataPoint)-mean(Com5ch1(1:maxDataPoint)));
NormalizedCom6ch0 = (Com6ch0(1:maxDataPoint)-mean(Com6ch0(1:maxDataPoint)))./norm(Com6ch0(1:maxDataPoint)-mean(Com6ch0(1:maxDataPoint)));
NormalizedCom6ch1 = (Com6ch1(1:maxDataPoint)-mean(Com6ch1(1:maxDataPoint)))./norm(Com6ch1(1:maxDataPoint)-mean(Com6ch1(1:maxDataPoint)));
NormalizedCom7ch0 = (Com7ch0(1:maxDataPoint)-mean(Com7ch0(1:maxDataPoint)))./norm(Com7ch0(1:maxDataPoint)-mean(Com7ch0(1:maxDataPoint)));
NormalizedCom7ch1 = (Com7ch1(1:maxDataPoint)-mean(Com7ch1(1:maxDataPoint)))./norm(Com7ch1(1:maxDataPoint)-mean(Com7ch1(1:maxDataPoint)));
NormalizedCom8ch0 = (Com8ch0(1:maxDataPoint)-mean(Com8ch0(1:maxDataPoint)))./norm(Com8ch0(1:maxDataPoint)-mean(Com8ch0(1:maxDataPoint)));
NormalizedCom8ch1 = (Com8ch1(1:maxDataPoint)-mean(Com8ch1(1:maxDataPoint)))./norm(Com8ch1(1:maxDataPoint)-mean(Com8ch1(1:maxDataPoint)));

[cor5,lag5] = xcorr(NormalizedCom5ch0,NormalizedCom5ch1);
[cor6,lag6] = xcorr(NormalizedCom6ch0,NormalizedCom6ch1);
[cor7,lag7] = xcorr(NormalizedCom7ch0,NormalizedCom7ch1);
[cor8,lag8] = xcorr(NormalizedCom8ch0,NormalizedCom8ch1);

[cor56,lag56] = xcorr(NormalizedCom5ch0,NormalizedCom6ch0);
[cor57,lag57] = xcorr(NormalizedCom5ch0,NormalizedCom7ch0);
[cor58,lag58] = xcorr(NormalizedCom5ch0,NormalizedCom8ch0);

% figure;
% stairs(lag5,cor5);
% hold on;
% stairs(lag6,cor6);
% hold on;
% stairs(lag7,cor7);
% hold on;
% stairs(lag8,cor8);
% legend('COM5','COM6','COM7','COM8');
% title('Cross-correlation between Channels');
% xlabel('time (data point)');
%
% figure;
% stairs(lag56,cor56);
% hold on;
% stairs(lag57,cor57);
% hold on;
% stairs(lag58,cor58);
% legend('COM5 and COM6','COM5 and COM7','COM5 and COM8');
% title('Cross-correlation between Sensors');
% xlabel('time (data point)');

figure;
subplot(2,2,1);
stairs(lag5,cor5);
title('Cross-correlation between Channels (COM5)');
xlabel('time (data point)');
subplot(2,2,2);
stairs(lag6,cor6);
title('Cross-correlation between Channels (COM6)');
xlabel('time (data point)');
subplot(2,2,3);
stairs(lag7,cor7);
title('Cross-correlation between Channels (COM7)');
xlabel('time (data point)');
subplot(2,2,4);
stairs(lag8,cor8);
title('Cross-correlation between Channels (COM8)');
xlabel('time (data point)');

figure;
subplot(3,1,1);
stairs(lag56,cor56);
title('Cross-correlation between Sensors (COM5 and COM6)');
xlabel('time (data point)');
subplot(3,1,2);
stairs(lag57,cor57);
title('Cross-correlation between Sensors (COM5 and COM7)');
xlabel('time (data point)');
subplot(3,1,3);
stairs(lag58,cor58);
title('Cross-correlation between Sensors (COM5 and COM8)');
xlabel('time (data point)');


