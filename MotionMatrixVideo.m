% This file is used to show motion matrix and real video
% Input: Video data
% Output: Motion matrix and real video

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

video_dirs = 'D:/Philips/Database/HumanFan/Video20170120_twoperson/';
extension = 'jpg';
resnames = dir(fullfile(video_dirs,['*.' extension]));
load('HumanFanTwoPersonMotionMatrixSmallArea.mat');
filename = 'HumanFanTwoPerson';

for i = 1:length(resnames)
    VideoTimeLabel(i,1) = str2double(resnames(i).name(end-10:end-4));
end

VHour = floor(VideoTimeLabel/10000);
VMinute = floor((VideoTimeLabel-VHour*10000)/100);
VSecond = floor(VideoTimeLabel-VHour*10000-VMinute*100);
VTime = VHour*3600+VMinute*60+VSecond;
ReferedLabel = VTime(1):VTime(end);
[ReducedInteger, IntegerLabel, ~] = intersect(ReferedLabel', VTime);

%% Make Animation

axis tight manual
ax = gca;
ax.NextPlot = 'replaceChildren';
% F(loops) = struct('cdata',[],'colormap',[]);
set(gcf, 'renderer', 'painters')

aviname = 'HumanFanTwoPerson (Delete Noise).avi';
aviObj = VideoWriter(aviname);
v.CompressionRatio = 3;
open(aviObj);

for j = 1:1:length(resnames)
    subplot(1,2,1);
    img = imread(fullfile(video_dirs,resnames(j).name));
    % imshow(img);
    imshow(img(100:1100,200:1300));
    title(filename);
    hsp1 = get(gca, 'Position');
    subplot(1,2,2);
    imagesc(Motion(:,:,j));
    colorbar;
    title('Motion Matrix');
    hsp2 = get(gca, 'Position');
    set(gca, 'Position', [0.5703,0.3700,0.3317,0.3850]);
    drawnow
    %F(j) = getframe(gcf);
    pause(0.3)
    currFrame = getframe(gcf);
    writeVideo(aviObj,currFrame);
end

close(aviObj);
