% This file is used to label activity levels for moving windows
% Input: Threshold values of different activity levels
% Output: Activity levels of windows

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Database includes
% HumanFan Activity: 1. GeorgesWalkInOutWithFan: HumanFan/Video20160831_165421_walking_in_the_room_with_fan
%                       HumanFan/20160831_165421_walking_in_the_room_with_fan/COM5_walking_in_the_room_with_fan_20160831_165421.mat
%                    1'. TwoPersonActiveWithFan: HumanFan/Video20170120_twoperson
%                        HumanFan/20170120_twoperson/COM5_Actilume_raw_data_20170120_161603.mat
% Human Activity: 2. XiukunSitStand20Second: Human/20160517_112337_Video_SittingStandingBelowSensors_Xiukun_trial1_20sec_30min
% (total No.7)       Human/20160517_112337_SittingStandingBelowSensors_Xiukun_trial1_20sec_30min/COM5_SittingStandingBelowSensors_Xiukun_trial1_20sec_20160517_112337.mat
%                 3. MajaSitStand40Second: Human/20160517_131445_Video_SittingStandingBelowSensors_Maja_trial1_40sec_30min
%                    Human/20160517_131445_SittingStandingBelowSensors_Maja_trial1_40sec_30min/COM5_SittingStandingBelowSensors_Maja_trial1_40sec_20160517_131445.mat
%                 4. MajaSitStand120Second: Human/20160517_152540_Video_SittingStandingBelowSensors_Maja_trial1_120sec_30min
%                    Human/20160517_152540_SittingStandingBelowSensors_Maja_trial1_120sec_30min/COM5_SittingStandingBelowSensors_Maja_trial1_120sec_20160517_152540.mat
%                 5. MajaArmLeftRight: Human/Video20160721_140536Maja_left_right_60s_belowsensors_A70
%                 6. GeorgesPutFanAway: Human/Video20160831_Georges_Putting_fan_away
%                 7. GeorgesWalkInOutWithoutFan: Human/Video20160831_163913_walking_in_the_room_without_fan
%                    Human/20160831_163913_walking_in_the_room_without_fan/COM5_walking_in_the_room_without_fan_20160831_163913.mat
%                 8. TwoPersonActiveWithoutFan: Human/Video_FanOffPersonActiveIntheRoom_20160912_171415
%                    Human/FanOffPersonActiveIntheRoom_20160912_171415/COM5_FanOffPersonActiveIntheRoom_20160912_171415.mat
% RobotActivity: 9. RobotArmUpDown1Second: Robot/Video_20160526_103056RobotArmBelowSensors_1sup_1sdown
% (total No.18) 10. RobotArmUpDown2Second: Robot/Video_20160526_114213RobotArmBelowSensors_2sup_2sdown
%               11. RobotArmUpDown5Second: Robot/Video_20160526_122943RobotArmBelowSensors_5sup_5sdown
%               12. RobotArmUpDown10Second: Robot/Video_20160526_130227RobotArmBelowSensors_10sup_10sdown
%               13. RobotArmUpDown20Second: Robot/Video_20160526_133443_RobotArmBelowSensors_20sup_20sdown
%               14. RobotArmUpDown40Second: Robot/Video_20160526_140448RobotArmBelowSensors_40sup_40sdown
%                   Robot/20160526_140448RobotArmBelowSensors_40sup_40sdown/COM5_RobotArmBelowSensors_40sup_40sdown_20160526_140448.mat
%               15. RobotArmUpDown60Second: Robot/Video_20160526_143815RobotArmBelowSensors_60sup_60sdown
%               16. RobotArmUpDown120Second: Robot/Video_20160526_151513RobotArmBelowSensors_120sup_120sdown
%               17. RobotArmNonSystematicBelowSensor: Robot/Video20160621_121400RobortArmNonSystematic_belowSensors
%               18. RobotArmNonSystematicBox4: Robot/Video20160621_130421RobotArmNonSystematic_Box4_75cm
%               19. RobotArmNonSystematicBox3: Robot/Video20160621_140400RobotArmNonSystematic_Box3_75cm
%               20. RobotArmNonSystematicBox2: Robot/Video20160621_150224RobotArmNonSystematic_Box2_75cm
%               21. RobotArmNonSystematicBox1: Robot/Video20160621_160310RobotArmNonSystematic_Box1_75cm
%               22. RobotArmLeftRight60Second: Robot/Video20160721_102938RobotArm_left_right_60s_belowsensors
%               23. RobotArmLeftRight60SecondA20S240: Robot/Video20160721_111702COM5_RobotArm_left_right_60s_belowsensors_A20_S_240
%               24. RobotArmLeftRight60SecondA20S60: Robot/Video20160721_114531RobotArm_left_right_60s_belowsensors_A20_S_60
%               25. RobotArmLeftRight60SecondA70S60: Robot/Video20160721_120659RobotArm_left_right_60s_belowsensors_A70_S_60
%               26. RobotArmLeftRight60SecondA20S60Box1: Robot/Video20160721_132319RobotArm_left_right_60s_A20_S_60_Box1_141cm

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear;
clc;
close all;

%% Load Data

video_dirs = 'D:/Philips/Database/Robot/Video_20160526_140448RobotArmBelowSensors_40sup_40sdown/';
extension = 'jpg';
resnames = dir(fullfile(video_dirs,['*.' extension]));

load('D:/Philips/Database/Robot/20160526_140448RobotArmBelowSensors_40sup_40sdown/COM5_RobotArmBelowSensors_40sup_40sdown_20160526_140448.mat');
% Data table: Hour (the first column), ... , Ch0 (the forth column), ...
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

load('RobotArmUpDown40SecondMotionMatrixSmallArea.mat');
labelname = 'RobotArmUpDown40SecondActivityLabel';

%% Align Time

for i = 1:length(resnames)
    VideoTimeLabel(i,1) = str2double(resnames(i).name(end-9:end-4));
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

%% Activity Clusters

windowsize = 10;  % unit: second
shiftsize = 1;    % unit: second

TotalNumber = length(EigValue(1,VideoLabelStart:VideoLabelEnd));
MaxEigenMean = zeros(TotalNumber,1);
SecondEigenMean = zeros(TotalNumber,1);
ThirdEigenMean = zeros(TotalNumber,1);

for i = windowsize:shiftsize:TotalNumber
    MaxEigenMean(i) = mean(EigValue(1,VideoLabelStart+i-windowsize:VideoLabelStart+i-1));
    SecondEigenMean(i) = mean(EigValue(2,VideoLabelStart+i-windowsize:VideoLabelStart+i-1));
    ThirdEigenMean(i) = mean(EigValue(3,VideoLabelStart+i-windowsize:VideoLabelStart+i-1));
end

load('Threshold.mat');

ScaledMaxEigenMean = MaxEigenMean./MaxFirstEigen;
ScaledSecondEigenMean = SecondEigenMean./MaxSecondEigen;
ScaledThirdEigenMean = ThirdEigenMean./MaxThirdEigen;

%% Label Activity Levels

load('ThresholdFan.mat');
MaxThreshold = MaxThreshold-0.05;
SecondThreshold = SecondThreshold-0.05;
MaxThreshold = MaxThreshold-0.05;

for i = windowsize:shiftsize:TotalNumber
    for j = 1:4
        Dist(i,j)=(ScaledMaxEigenMean(i)-MaxThreshold(j))^2+(ScaledSecondEigenMean(i)-SecondThresholdSample(j))^2+(ScaledThirdEigenMean(i)-ThirdThresholdSample(j))^2;
    end
    Label(i)=(find(Dist(i,1:4)==min(Dist(i,1:4))))-1;
end

figure;
stem(Label);
title('Activity Level of Each Moving Window');
xlabel('time (second)');
ylabel('activity level');

AlignedCh0 = Ch0(SignalLabelStart:SignalLabelEnd);
IntegerCh0 = AlignedCh0(FinalSignalLabel);
NormalizedCh0 = (IntegerCh0-mean(IntegerCh0))./norm(IntegerCh0-mean(IntegerCh0));
MaxEigenvalue = EigValue(1,VideoLabelStart:VideoLabelEnd);
NormalizedMaxEigenvalue = (MaxEigenvalue)./norm(MaxEigenvalue);

figure;
plot(NormalizedCh0,'LineWidth',2);
hold on
plot(NormalizedMaxEigenvalue,'LineWidth',2);
hold on
stem(Label);
title('Signal and Activity Level');
xlabel('maximal eigenvalue');
ylabel('second largest eigenvalue');
legend('normalized signal (COM5 Ch0)','normalized maximal eigenvalue','activity level');

save(labelname, 'Label');
