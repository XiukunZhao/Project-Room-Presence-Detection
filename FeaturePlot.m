% This file is used to show features
% Input: Features
% Output: Plot

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 17 dimensional features base includes:
%  01. Window Mean value
%  02. Window variance
%  03. Variation
%  04. Total number of peaks
%  05. Max amplitude of positive peaks
%  06. Max amplitude of negative peaks
%  07. Average of distances between two successive peaks
%  08. Coefficient of variation of peak distances
%  09. Average peak widths
%  10. Coefficient of variation of peak widths
%  11. Fraction of energy stored in peaks
%  12. Half Energy
%  13. Number of frequencies involved in half of Energy (p)
%  14. Maximum magnitude
%  15. Frequency of maximum magnitude (in Hz)
%  16. Average distance between two successive frequencies (in Hz)
%  17. Coefficient of variation of frequency distances

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% HumanFan Activity: 1. GeorgesWalkInOutWithFan: HumanFan/Video20160831_165421_walking_in_the_room_with_fan
%                       HumanFan/20160831_165421_walking_in_the_room_with_fan/COM5_walking_in_the_room_with_fan_20160831_165421.mat
%                    2. HumanFan/Video20170120_twoperson
%                       HumanFan/20170120_twoperson/COM5_Actilume_raw_data_20170120_161603.mat
% Human Activity: 3. MajaSitStand40Second: Human/20160517_131445_Video_SittingStandingBelowSensors_Maja_trial1_40sec_30min
%                 Human/20160517_131445_SittingStandingBelowSensors_Maja_trial1_40sec_30min/COM5_SittingStandingBelowSensors_Maja_trial1_40sec_20160517_131445.mat
%                 7. GeorgesWalkInOutWithoutFan: Human/Video20160831_163913_walking_in_the_room_without_fan
%                 Human/20160831_163913_walking_in_the_room_without_fan/COM5_walking_in_the_room_without_fan_20160831_163913.mat
%                 8. TwoPersonsActiveInRoom: Human/Video_FanOffPersonActiveIntheRoom_20160912_171415
%                 Human/FanOffPersonActiveIntheRoom_20160912_171415/COM5_FanOffPersonActiveIntheRoom_20160912_171415.mat
% RobotActivity: 14. RobotArmUpDown40Second: Robot/Video_20160526_140448RobotArmBelowSensors_40sup_40sdown
%                Robot/20160526_140448RobotArmBelowSensors_40sup_40sdown/COM5_RobotArmBelowSensors_40sup_40sdown_20160526_140448.mat

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc;
clear;
close all;

%% Load Data

video_dirs = 'D:/Philips/Database/HumanFan/Video20160831_165421_walking_in_the_room_with_fan/';
extension = 'jpg';
resnames = dir(fullfile(video_dirs,['*.' extension]));

load('D:/Philips/Database/HumanFan/20160831_165421_walking_in_the_room_with_fan/COM5_walking_in_the_room_with_fan_20160831_165421.mat');
Data = table2array(Data);
Hour = Data(:,1);
Minute = Data(:,2);
Second = Data(:,3);
Ch0 = Data(:,4);
Ch1 = Data(:,5);
Temp = Data(:,6);
Det = Data(:,7);
OldDet = Data(:,8);
STime = Hour*3600+Minute*60+floor(Second);

load('GeorgesWalkInOutWithFanFeature.mat');

%% Align Time

for i = 1:length(resnames)
    VideoTimeLabel(i,1) = str2double(resnames(i).name(end-9:end-4));  %9/4,15/9
end

VHour = floor(VideoTimeLabel/10000);
VMinute = floor((VideoTimeLabel-VHour*10000)/100);
VSecond = floor(VideoTimeLabel-VHour*10000-VMinute*100);
VTime = VHour*3600+VMinute*60+VSecond;

TimeStart = max(VTime(1), STime(1));
TimeEnd = min(VTime(end), STime(end));
VideoLabelStart = find(VTime == TimeStart);
VideoLabelEnd = find(VTime == TimeEnd);
Index = VTime(VideoLabelStart:VideoLabelEnd);
FinalVTime = Index-Index(1);

SignalLabelStart = find(STime == TimeStart, 1);
SignalLabelEnd = find(STime == TimeEnd, 1, 'last');

ReadingTime = Hour(SignalLabelStart:SignalLabelEnd)*3600+Minute(SignalLabelStart:SignalLabelEnd)*60+Second(SignalLabelStart:SignalLabelEnd);
Time = ReadingTime-ReadingTime(1);
IntegerTime = floor(Time);
[IntegerSignal, SignalShowLabel, ~] = unique(IntegerTime);
[ReducedIntegerSignal, IntegerSignalLabel, ~] = intersect(IntegerSignal, FinalVTime);
FinalSignalLabel = SignalShowLabel(IntegerSignalLabel);
EigenLabel = IntegerSignal(IntegerSignalLabel);

AlignedCh0 = Ch0(SignalLabelStart:SignalLabelEnd);
IntegerCh0 = AlignedCh0(FinalSignalLabel);
AlignedCh1 = Ch1(SignalLabelStart:SignalLabelEnd);
IntegerCh1 = AlignedCh1(FinalSignalLabel);
Period = 241:300;             % Enter
Period = 91:150;              % Leave

Featuresall = zeros(19+length(Features0),18);
Featuresall(19:19+length(Features0)-1,:) = Features0(1:length(Features0),:);
Features0 = Featuresall;
Period = 1:length(Features0);

%% Signal Plot

figure;
ReadingTime = Hour(SignalLabelStart:SignalLabelEnd)*3600+Minute(SignalLabelStart:SignalLabelEnd)*60+Second(SignalLabelStart:SignalLabelEnd);
Time = ReadingTime-ReadingTime(1);
plot(Time, AlignedCh0(SignalLabelStart:SignalLabelEnd),'b');
title('COM5 Ch0');
xlabel('time (second)');
ylabel('signal');

figure;
stem(Time(FinalSignalLabel),Features0(Period,1));
title('Feature 1 (mean)');
xlabel('window');
ylabel('feature');
ylim([7500 8500]);

figure;
stem(Time(FinalSignalLabel),Features0(Period,2));
title('Feature 2 (variance)');
xlabel('window');
ylabel('feature');

figure;
stem(Time(FinalSignalLabel),Features0(Period,3));
title('Feature 3 (variation)');
xlabel('window');
ylabel('feature');

figure;
stem(Time(FinalSignalLabel),Features0(Period,4));
title('Feature 4 (number of peaks)');
xlabel('window');
ylabel('feature');

figure;
stem(Time(FinalSignalLabel),Features0(Period,5));
title('Feature 5 (max amplitude)');
xlabel('window');
ylabel('feature');

figure;
stem(Time(FinalSignalLabel),Features0(Period,6));
title('Feature 6 (min amplitude)');
xlabel('window');
ylabel('feature');

figure;
stem(Time(FinalSignalLabel),Features0(Period,7));
title('Feature 7 (average of distances)');
xlabel('window');
ylabel('feature');

figure;
stem(Time(FinalSignalLabel),Features0(Period,8));
title('Feature 8 (SD of distances)');
xlabel('window');
ylabel('feature');

figure;
stem(Time(FinalSignalLabel),Features0(Period,9));
title('Feature 9 (average of peak widths)');
xlabel('window');
ylabel('feature');

figure;
stem(Time(FinalSignalLabel),Features0(Period,10));
title('Feature 10 (SD of peak widths)');
xlabel('window');
ylabel('feature');

figure;
stem(Time(FinalSignalLabel),Features0(Period,11));
title('Feature 11 (total energy in peaks)');
xlabel('window');
ylabel('feature');

figure;
stem(Time(FinalSignalLabel),Features0(Period,12));
title('Feature 12 (half energy)');
xlabel('window');
ylabel('feature');

figure;
stem(Time(FinalSignalLabel),Features0(Period,13));
title('Feature 13 (number of frequencies in half energy)');
xlabel('window');
ylabel('feature');

figure;
stem(Time(FinalSignalLabel),Features0(Period,14));
title('Feature 14 (max magnitude)');
xlabel('window');
ylabel('feature');

figure;
stem(Time(FinalSignalLabel),Features0(Period,15));
title('Feature 15 (frequency of max magnitude)');
xlabel('window');
ylabel('feature');

figure;
stem(Time(FinalSignalLabel),Features0(Period,16));
title('Feature 16 (average of distances between two peaks)');
xlabel('window');
ylabel('feature');

figure;
stem(Time(FinalSignalLabel),Features0(Period,17));
title('Feature 17 (SD of distances)');
xlabel('window');
ylabel('feature');
