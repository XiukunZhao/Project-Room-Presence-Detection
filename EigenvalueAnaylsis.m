% This file is used to analyze the eigenvalues of motion matrix
% Input: Video data
% Output: Correlation and cross-correlation of the three largest eigenvalues

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Database includes
% HumanFan Activity: 1. GeorgesWalkInOutWithFan: HumanFan/Video20160831_165421_walking_in_the_room_with_fan
%                    2. TwoPersonActiveWithFan: HumanFan/Video20170120_twoperson
% Human Activity: 1. XiukunSitStand20Second: Human/20160517_112337_Video_SittingStandingBelowSensors_Xiukun_trial1_20sec_30min
%                 2. MajaSitStand40Second: Human/20160517_131445_Video_SittingStandingBelowSensors_Maja_trial1_40sec_30min
%                 3. MajaSitStand120Second: Human/20160517_152540_Video_SittingStandingBelowSensors_Maja_trial1_120sec_30min
%                 4. MajaArmLeftRight: Human/Video20160721_140536Maja_left_right_60s_belowsensors_A70
%                 5. GeorgesPutFanAway: Human/Video20160831_Georges_Putting_fan_away
%                 6. GeorgesWalkInOutWithoutFan: Human/Video20160831_163913_walking_in_the_room_without_fan
%                 7. TwoPersonActiveWithoutFan: Human/Video_FanOffPersonActiveIntheRoom_20160912_171415
% RobotActivity: 1. RobotArmUpDown1Second: Robot/Video_20160526_103056RobotArmBelowSensors_1sup_1sdown
%                2. RobotArmUpDown2Second: Robot/Video_20160526_114213RobotArmBelowSensors_2sup_2sdown
%                3. RobotArmUpDown5Second: Robot/Video_20160526_122943RobotArmBelowSensors_5sup_5sdown
%                4. RobotArmUpDown10Second: Robot/Video_20160526_130227RobotArmBelowSensors_10sup_10sdown
%                5. RobotArmUpDown20Second: Robot/Video_20160526_133443_RobotArmBelowSensors_20sup_20sdown
%                6. RobotArmUpDown40Second: Robot/Video_20160526_140448RobotArmBelowSensors_40sup_40sdown
%                7. RobotArmUpDown60Second: Robot/Video_20160526_143815RobotArmBelowSensors_60sup_60sdown
%                8. RobotArmUpDown120Second: Robot/Video_20160526_151513RobotArmBelowSensors_120sup_120sdown
%                9. RobotArmNonSystematicBelowSensor: Robot/Video20160621_121400RobortArmNonSystematic_belowSensors
%                10. RobotArmNonSystematicBox4: Robot/Video20160621_130421RobotArmNonSystematic_Box4_75cm
%                11. RobotArmNonSystematicBox3: Robot/Video20160621_140400RobotArmNonSystematic_Box3_75cm
%                12. RobotArmNonSystematicBox2: Robot/Video20160621_150224RobotArmNonSystematic_Box2_75cm
%                13. RobotArmNonSystematicBox1: Robot/Video20160621_160310RobotArmNonSystematic_Box1_75cm
%                14. RobotArmLeftRight60Second: Robot/Video20160721_102938RobotArm_left_right_60s_belowsensors
%                15. RobotArmLeftRight60SecondA20S240: Robot/Video20160721_111702COM5_RobotArm_left_right_60s_belowsensors_A20_S_240
%                16. RobotArmLeftRight60SecondA20S60: Robot/Video20160721_114531RobotArm_left_right_60s_belowsensors_A20_S_60
%                17. RobotArmLeftRight60SecondA70S60: Robot/Video20160721_120659RobotArm_left_right_60s_belowsensors_A70_S_60
%                18. RobotArmLeftRight60SecondA20S60Box1: Robot/Video20160721_132319RobotArm_left_right_60s_A20_S_60_Box1_141cm

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear;
clc;
close all;

video_dirs = 'D:/Philips/Database/Human/Video_FanOffPersonActiveIntheRoom_20160912_171415/';
extension = 'jpg';
resnames = dir(fullfile(video_dirs,['*.' extension]));
load('TwoPersonsActiveInRoomMotionMatrixSmallArea.mat');
filename = 'TwoPersonsActiveInRoom';

%% Corraltion of Eigenvalues

EigenMean = mean(EigValue,2);
EigenMax = max(EigValue,[],2);
CorrCoefMatrix = corrcoef([EigValue(1,:)',EigValue(2,:)',EigValue(3,:)']);
LargestEigenMean = EigenMean(1);
LargestEigenMax = EigenMax(1);

figure;
plot(1:length(EigValue),EigValue);
title('Eigenvalues of Motion Matrix');
xlabel('time (second)');
ylabel('eigenvalue');
legend('\lambda_{1} (\lambda_{max})', '\lambda_{2}', '\lambda_{3}', '\lambda_{4}','\lambda_{5}');

%% Cross-corraltion of First Three largest Eigenvalues

NormalizedLargestEigvalue = EigValue(1,:)./norm(EigValue(1,:));        % normalized eigenvalues
NormalizedSecondEigvalue = EigValue(2,:)./norm(EigValue(2,:));
NormalizedThirdEigvalue = EigValue(3,:)./norm(EigValue(3,:));
[cor12,lag12] = xcorr(NormalizedLargestEigvalue,NormalizedSecondEigvalue);
[cor13,lag13] = xcorr(NormalizedLargestEigvalue,NormalizedThirdEigvalue);

figure;
stairs(lag12,cor12);
hold on;
stairs(lag13,cor13);
legend('\lambda_{1} and \lambda_{2}','\lambda_{1} and \lambda_{3}');
title('Cross-correlation between Eigenvalues of Motion Matrix');
xlabel('time (second)')



