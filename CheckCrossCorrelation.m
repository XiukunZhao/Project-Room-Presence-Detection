% This file is used to calculate the cross-correlation between signals and motion
% Input: Signal data of sensors and eigenvalues
% Output: Cross-correlation between eight signals and eigenvalues

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Database includes
% HumanFan Activity: 1. GeorgesWalkInOutWithFan: HumanFan/Video20160831_165421_walking_in_the_room_with_fan
%                       HumanFan/20160831_165421_walking_in_the_room_with_fan/COM5_walking_in_the_room_with_fan_20160831_165421.mat
%                    1'. TwoPersonActiveWithFan: HumanFan/Video20170120_twoperson
%                        HumanFan/20170120_twoperson/COM5_Actilume_raw_data_20170120_161603.mat
% Human Activity: 2. XiukunSitStand20Second: Human/20160517_112337_Video_SittingStandingBelowSensors_Xiukun_trial1_20sec_30min
% (total No.7)    Human/20160517_112337_SittingStandingBelowSensors_Xiukun_trial1_20sec_30min/COM5_SittingStandingBelowSensors_Xiukun_trial1_20sec_20160517_112337.mat
%                 3. MajaSitStand40Second: Human/20160517_131445_Video_SittingStandingBelowSensors_Maja_trial1_40sec_30min
%                 4. MajaSitStand120Second: Human/20160517_152540_Video_SittingStandingBelowSensors_Maja_trial1_120sec_30min
%                 5. MajaArmLeftRight: Human/Video20160721_140536Maja_left_right_60s_belowsensors_A70
%                 6. GeorgesPutFanAway: Human/Video20160831_Georges_Putting_fan_away
%                 7. GeorgesWalkInOutWithoutFan: Human/Video20160831_163913_walking_in_the_room_without_fan
%                 Human/20160831_163913_walking_in_the_room_without_fan/COM5_walking_in_the_room_without_fan_20160831_163913.mat
%                 8. TwoPersonsActiveInRoom: Human/Video_FanOffPersonActiveIntheRoom_20160912_171415
% RobotActivity: 9. RobotArmUpDown1Second: Robot/Video_20160526_103056RobotArmBelowSensors_1sup_1sdown
% (total No.18) 10. RobotArmUpDown2Second: Robot/Video_20160526_114213RobotArmBelowSensors_2sup_2sdown
%               11. RobotArmUpDown5Second: Robot/Video_20160526_122943RobotArmBelowSensors_5sup_5sdown
%               12. RobotArmUpDown10Second: Robot/Video_20160526_130227RobotArmBelowSensors_10sup_10sdown
%               13. RobotArmUpDown20Second: Robot/Video_20160526_133443_RobotArmBelowSensors_20sup_20sdown
%               14. RobotArmUpDown40Second: Robot/Video_20160526_140448RobotArmBelowSensors_40sup_40sdown
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

video_dirs = 'D:/Philips/Database/Human/Video20160831_163913_walking_in_the_room_without_fan/';
extension = 'jpg';
resnames = dir(fullfile(video_dirs,['*.' extension]));

load('D:/Philips/Database/Human/20160831_163913_walking_in_the_room_without_fan/COM5_walking_in_the_room_without_fan_20160831_163913.mat');
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

load('WalkInOutMotionMatrixSmallArea.mat');

%% Align Time

for i = 1:length(resnames)
    VideoTimeLabel(i,1) = str2double(resnames(i).name(end-10:end-4));
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

%% Normalize Signals and Eigenvalue

AlignedCh0 = Ch0(SignalLabelStart:SignalLabelEnd);
IntegerCh0 = AlignedCh0(FinalSignalLabel);
MaxEigenvalue = EigValue(1,VideoLabelStart:VideoLabelEnd);
SecEigenvalue = EigValue(2,VideoLabelStart:VideoLabelEnd);
AlignedCh1 = Ch1(SignalLabelStart:SignalLabelEnd);
IntegerCh1 = AlignedCh1(FinalSignalLabel);

NormalizedCh0 = abs(IntegerCh0-mean(IntegerCh0))./norm(abs(IntegerCh0-mean(IntegerCh0)));
NormalizedCh1 = abs(IntegerCh1-mean(IntegerCh1))./norm(abs(IntegerCh1-mean(IntegerCh1)));
NormalizedMaxEigenvalue = (MaxEigenvalue)./norm(MaxEigenvalue);
NormalizedSecEigenvalue = (SecEigenvalue)./norm(SecEigenvalue);

figure;
plot(NormalizedCh0);
hold on
plot(NormalizedCh1);
hold on
plot(NormalizedMaxEigenvalue);
legend('Signal Ch0','Signal Ch1','Motion (largest eigenvalue)');
title('Normalized Singals and Eigenvalue');

%% Calculate Cross-correlaion of Signals and Maximal Eigenvalue

[cor0,lag0] = xcorr(NormalizedCh0,NormalizedMaxEigenvalue);
[cor1,lag1] = xcorr(NormalizedCh1,NormalizedMaxEigenvalue);

figure;                    % Show cross-correlation between the largest eigenvalue and signals
stairs(lag0,cor0);
hold on;
stairs(lag1,cor1);
legend('Ch0','Ch1');
title('Cross-correlation of Singal and Motion (largest eigenvalue)');
%% Calculate Cross-correlaion of Signals and Second Largest Eigenvalue

[cor0,lag0] = xcorr(NormalizedCh0,NormalizedSecEigenvalue);
[cor1,lag1] = xcorr(NormalizedCh1,NormalizedSecEigenvalue);

figure;                    % Show cross-correlation between the second largest eigenvalue and signals
stairs(lag0,cor0);
hold on;
stairs(lag1,cor1);
legend('Ch0','Ch1');
title('Cross-correlation of Singal and Motion (second largest eigenvalue)');

%% Calculate Correlaion of Signals and Maximal Eigenvalue

CorrCoefMatrix = corrcoef([NormalizedCh0,NormalizedCh1,NormalizedMaxEigenvalue']);
