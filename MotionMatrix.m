% This file is used to compute motion matrix from the whole video (delete a part of image to avoid noise)
% Input: Video data
% Output: Motion matrix and eigenvalues

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

%% Read Video Data

video_dirs = 'D:/Philips/Database/Human/Video_FanOffPersonActiveIntheRoom_20160912_171415/';
extension = 'jpg';
resnames = dir(fullfile(video_dirs,['*.' extension]));

BlockSize = [141 141];                       % Resulation: the value can be chosen till [601,801]
hbm = vision.BlockMatcher('ReferenceFrameSource','Input port','BlockSize',BlockSize);
hbm.OutputValue = 'Horizontal and vertical components in complex form';
% hbm.OutputValue = 'Magnitude-squared';     % MS = x^2+y^2, where z = x+yi

%% Full Image

% img1 = im2double(rgb2gray(imread(fullfile(video_dirs,resnames(1).name))));
% img2 = im2double(rgb2gray(imread(fullfile(video_dirs,resnames(2).name))));
% InitialSize = step(hbm,img1,img2);    % (Vx+iVy)
% motion = zeros(size(InitialSize,1),size(InitialSize,2),length(resnames));
% Motion = zeros(size(InitialSize,1),size(InitialSize,2),length(resnames));
% EigenValue = zeros(size(InitialSize,2),length(resnames));
% EigValue = zeros(size(InitialSize,1),length(resnames));

% for i = 1:length(resnames)-1
%     img1 = im2double(rgb2gray(imread(fullfile(video_dirs,resnames(i).name))));
%     img2 = im2double(rgb2gray(imread(fullfile(video_dirs,resnames(i+1).name))));
%     motion(:,:,i) = step(hbm,img1,img2);                                 % (Vx+iVy)
%     Motion(:,:,i) = abs(motion(:,:,i));                                  % sqrt(Vx^2+Vy^2)
%     EigenValue(:,i) = sqrt(eig(Motion(:,:,i)'*Motion(:,:,i)));
%     EigValue(:,i) = svd(Motion(:,:,i));
% end

%% Save Main Part of Image

img1 = im2double(rgb2gray(imread(fullfile(video_dirs,resnames(1).name))));
img2 = im2double(rgb2gray(imread(fullfile(video_dirs,resnames(2).name))));
InitialSize = step(hbm,img1(100:1100,200:1300),img2(100:1100,200:1300));
motion = zeros(size(InitialSize,1),size(InitialSize,2),length(resnames));
Motion = zeros(size(InitialSize,1),size(InitialSize,2),length(resnames));
EigValue = zeros(size(InitialSize,1),length(resnames));

figure;                                            % Show detection area of image
imshow(img1(100:1100,200:1300));
title('Detection Area of Image');
figure;                                            % Show original image
imshow(img1);
title('Original Image');

for i = 1:length(resnames)-1
    img1 = im2double(rgb2gray(imread(fullfile(video_dirs,resnames(i).name))));
    img2 = im2double(rgb2gray(imread(fullfile(video_dirs,resnames(i+1).name))));
    motion(:,:,i+1) = step(hbm,img1(100:1100,200:1300),img2(100:1100,200:1300));
    Motion(:,:,i+1) = abs(motion(:,:,i+1));
    EigValue(:,i+1) = svd(Motion(:,:,i+1));
end

save TwoPersonActiveWithoutFanMotionMatrixSmallArea.mat motion Motion EigValue
% save eigenvalues of motion matrix

% %% Load Data to Plot Eigenvalue
%
% load('WalkInOutMotionMatrixSmallArea.mat');
%
% figure;
% imagesc(Motion(:,:,100));
% title('One Person Walk In and Out');
% colorbar;
%
% figure;                               % Show the three largest eigenvalues
% subplot(3,1,1);
% plot(EigValue(1,1:end));
% title('first largest eigenvalue');
% xlabel('time (second)');
% ylabel('\lambda_{1}');
% subplot(3,1,2);
% plot(EigValue(2,1:end));
% title('second largest eigenvalue');
% xlabel('time (second)');
% ylabel('\lambda_{2}');
% subplot(3,1,3);
% plot(EigValue(3,1:end));
% title('third largest eigenvalue');
% xlabel('time (second)');
% ylabel('\lambda_{3}');
% suptitle('One Person Walk In and Out');
