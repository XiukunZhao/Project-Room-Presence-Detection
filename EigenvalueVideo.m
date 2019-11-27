% This file is used to show a comparison of eigenvalues and video
% Input: Eigenvalues and video data
% Output: Animation shows origenal video (without noise) and three eigenvalues

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Database includes
% HumanFan Activity: 1. GeorgesWalkInOutWithFan: HumanFan/Video20160831_165421_walking_in_the_room_with_fan
%                    1'. TwoPersonActiveWithFan: HumanFan/Video20170120_twoperson
% Human Activity: 2. XiukunSitStand20Second: Human/20160517_112337_Video_SittingStandingBelowSensors_Xiukun_trial1_20sec_30min
% (total No.7)    3. MajaSitStand40Second: Human/20160517_131445_Video_SittingStandingBelowSensors_Maja_trial1_40sec_30min
%                 4. MajaSitStand120Second: Human/20160517_152540_Video_SittingStandingBelowSensors_Maja_trial1_120sec_30min
%                 5. MajaArmLeftRight: Human/Video20160721_140536Maja_left_right_60s_belowsensors_A70
%                 6. GeorgesPutFanAway: Human/Video20160831_Georges_Putting_fan_away
%                 7. GeorgesWalkInOutWithoutFan: Human/Video20160831_163913_walking_in_the_room_without_fan
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

clear
clc
close all

%% Read Video Data and Eigenvalues

video_dirs = 'D:/Philips/Database/HumanFan/Video20170120_twoperson/';
extension = 'jpg';
resnames = dir(fullfile(video_dirs,['*.' extension]));
load('TwoPersonsWithFanMotionMatrixSmallArea.mat');
filename = 'TwoPersonsWithFan';

for i = 1:length(resnames)
    VideoTimeLabel(i,1) = str2double(resnames(i).name(end-14:end-8));  % use (end-10:end-4) for some files
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
set(gcf, 'renderer', 'painters');

aviname = 'TwoPersonsWithFan.avi';
aviObj = VideoWriter(aviname);
v.CompressionRatio = 3;
open(aviObj);

for j = 1:1:length(resnames)
    subplot(3,2,1);
    plot(IntegerLabel,EigValue(1,:));
    line([IntegerLabel(j),IntegerLabel(j)],[min(EigValue(1,:)),max(EigValue(1,:))],'Color','r');
    title('maximal eigenvalue');
    xlabel('time (second)');
    ylabel('\lambda_{1}');
    subplot(3,2,3);
    plot(IntegerLabel,EigValue(2,:));
    line([IntegerLabel(j),IntegerLabel(j)],[min(EigValue(2,:)),max(EigValue(2,:))],'Color','r');
    title('second largest eigenvalue');
    xlabel('time (second)');
    ylabel('\lambda_{2}');
    subplot(3,2,5);
    plot(IntegerLabel,EigValue(3,:));
    line([IntegerLabel(j),IntegerLabel(j)],[min(EigValue(3,:)),max(EigValue(3,:))],'Color','r');
    title('third largest eigenvalue');
    xlabel('time (second)');
    ylabel('\lambda_{3}');
    subplot(1,2,2);
    img = imread(fullfile(video_dirs,resnames(j).name));
    % imshow(img(100:1100,150:1250));
    imshow(img);
    title(filename);
    drawnow
    pause(0.3)
    currFrame = getframe(gcf);
    writeVideo(aviObj,currFrame);
end

close(aviObj);
% fig = figure;
% movie(fig,F,2)