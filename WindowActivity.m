% This file is used to find average eigenvalues for each moving window
% Input: Video data, signal data, and eigenvalues of motion matrix
% Output: Average eigenvalues of each window (first three columns)

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

video_dirs = 'D:/Philips/Database/HumanFan/Video20160831_165421_walking_in_the_room_with_fan/';
extension = 'jpg';
resnames = dir(fullfile(video_dirs,['*.' extension]));

load('D:/Philips/Database/HumanFan/20160831_165421_walking_in_the_room_with_fan/COM5_walking_in_the_room_with_fan_20160831_165421.mat');
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

load('GeorgesWalkInOutWithFanMotionMatrixSmallArea.mat');
matname = 'GeorgesWalkInOutWithFanEigenMean';

%% Align Time

for i = 1:length(resnames)
    VideoTimeLabel(i,1) = str2double(resnames(i).name(end-9:end-4));  %13/8, 9/4,
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
plot(Time, Det(SignalLabelStart:SignalLabelEnd));

% %% Activity Clusters
%
% windowsize = 10;  % unit: second
% shiftsize = 1;    % unit: second
%
% TotalNumber = length(EigValue(1,VideoLabelStart:VideoLabelEnd));
% MaxEigenMean = zeros(TotalNumber,1);
% SecondEigenMean = zeros(TotalNumber,1);
% ThirdEigenMean = zeros(TotalNumber,1);
% % ScaledMaxEigenMean = zeros(TotalNumber,1);
% % ScaledSecondEigenMean = zeros(TotalNumber,1);
% % ScaledThirdEigenMean = zeros(TotalNumber,1);
% % ScaledMaxEigen = EigValue(1,:)./max(EigValue(1,:));
% % ScaledSecondEigen = EigValue(2,:)./max(EigValue(2,:));
% % ScaledThirdEigen = EigValue(3,:)./max(EigValue(3,:));
%
% for i = windowsize:shiftsize:TotalNumber
%     MaxEigenMean(i) = mean(EigValue(1,VideoLabelStart+i-windowsize:VideoLabelStart+i-1));
%     SecondEigenMean(i) = mean(EigValue(2,VideoLabelStart+i-windowsize:VideoLabelStart+i-1));
%     ThirdEigenMean(i) = mean(EigValue(3,VideoLabelStart+i-windowsize:VideoLabelStart+i-1));
%
% %     ScaledMaxEigenMean(i) = mean(ScaledMaxEigen(1,VideoLabelStart+i-windowsize:VideoLabelStart+i-1));
% %     ScaledSecondEigenMean(i) = mean(ScaledSecondEigen(1,VideoLabelStart+i-windowsize:VideoLabelStart+i-1));
% %     ScaledThirdEigenMean(i) = mean(ScaledThirdEigen(1,VideoLabelStart+i-windowsize:VideoLabelStart+i-1));
%
% end
%
% ScaledMaxEigenMean = MaxEigenMean./max(MaxEigenMean);
% ScaledSecondEigenMean = SecondEigenMean./max(SecondEigenMean);
% ScaledThirdEigenMean = ThirdEigenMean./max(ThirdEigenMean);
%
%
% WindowEigenvalue = [MaxEigenMean,SecondEigenMean,ThirdEigenMean,ScaledMaxEigenMean,ScaledSecondEigenMean,ScaledThirdEigenMean];
% % WindowEigenvalue: first three columns are the three largest eigenvalues,
% % last three columns are the three scaled largest eigenvalues
% WindowEigen = WindowEigenvalue(windowsize:end,:);     % First window starting from the tenth second
%
% save(matname, 'WindowEigen');
%
% %% Plot Clusters
%
% new_matrix = [ScaledMaxEigenMean,ScaledSecondEigenMean,ScaledThirdEigenMean];
% [cidx, ctrs] = kmeans(new_matrix, 5);
%
% plot3(new_matrix(cidx==1,1),new_matrix(cidx==1,2),new_matrix(cidx==1,3),'r.');
% hold on ; plot3(new_matrix(cidx==2,1),new_matrix(cidx==2,2),new_matrix(cidx==2,3),'b.');
% hold on ; plot3(new_matrix(cidx==3,1),new_matrix(cidx==3,2),new_matrix(cidx==3,3),'g.');
% hold on ; plot3(new_matrix(cidx==4,1),new_matrix(cidx==4,2),new_matrix(cidx==4,3),'y.');
% hold on ; plot3(new_matrix(cidx==5,1),new_matrix(cidx==5,2),new_matrix(cidx==5,3),'m.');
% hold on ; plot3( ctrs(:,1),ctrs(:,2),ctrs(:,3),'kx');
% grid on
% legend('Cluster 1','Cluster 2','Cluster 3','Cluster 4','Cluster 5','Centroids','Location','NW');
% title('Activity Clusters');
% xlabel('maximal eigenvalue');
% ylabel('second largest eigenvalue');
% zlabel('third largest eigenvalue');
% hold off

% figure;
% [counts, binValues] = hist(cidx, 5);
% bar(binValues, counts, 'barwidth', 1);
