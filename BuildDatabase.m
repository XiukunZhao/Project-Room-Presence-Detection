% This file is used to plot the signal data of sensors
% Input: .txt file consisting of raw signal data
% Output: .mat file consisting of signal data

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Database includes
% HumanFan Activity: 1. GeorgesWalkInOutWithFan: HumanFan/20160831_165421_walking_in_the_room_with_fan
%                    1'. TwoPersonActiveWithFan: HumanFan/20170120_twoperson
% Human Activity: 2. XiukunSitStand20Second: Human/20160517_112337_SittingStandingBelowSensors_Xiukun_trial1_20sec_30min
% (total No.7)    3. MajaSitStand40Second: Human/20160517_131445_SittingStandingBelowSensors_Maja_trial1_40sec_30min
%                 4. MajaSitStand120Second: Human/20160517_152540_SittingStandingBelowSensors_Maja_trial1_120sec_30min
%                 5. MajaArmLeftRight: Human/20160721_140536Maja_left_right_60s_belowsensors_A70
%                 6. GeorgesPutFanAway: Human/20160831_154213_Georges_Putting_fan_away
%                 7. GeorgesWalkInOutWithoutFan: Human/20160831_163913_walking_in_the_room_without_fan
%                 8. TwoPersonsActiveInRoom: Human/FanOffPersonActiveIntheRoom_20160912_171415
% RobotActivity: 9. RobotArmUpDown1Second: Robot/20160526_103056RobotArmBelowSensors_1sup_1sdown
% (total No.18) 10. RobotArmUpDown2Second: Robot/20160526_114213RobotArmBelowSensors_2sup_2sdown
%               11. RobotArmUpDown5Second: Robot/20160526_122943RobotArmBelowSensors_5sup_5sdown
%               12. RobotArmUpDown10Second: Robot/20160526_130227RobotArmBelowSensors_10sup_10sdown
%               13. RobotArmUpDown20Second: Robot/20160526_133443_RobotArmBelowSensors_20sup_20sdown
%               14. RobotArmUpDown40Second: Robot/20160526_140448RobotArmBelowSensors_40sup_40sdown
%               15. RobotArmUpDown60Second: Robot/20160526_143815RobotArmBelowSensors_60sup_60sdown
%               16. RobotArmUpDown120Second: Robot/20160526_151513RobotArmBelowSensors_120sup_120sdown
%               17. RobotArmNonSystematicBelowSensor: Robot/20160621_121400RobortArmNonSystematic_belowSensors
%               18. RobotArmNonSystematicBox4: Robot/20160621_130421RobotArmNonSystematic_Box4_75cm
%               19. RobotArmNonSystematicBox3: Robot/20160621_140400RobotArmNonSystematic_Box3_75cm
%               20. RobotArmNonSystematicBox2: Robot/20160621_150224RobotArmNonSystematic_Box2_75cm
%               21. RobotArmNonSystematicBox1: Robot/20160621_160310RobotArmNonSystematic_Box1_75cm
%               22. RobotArmLeftRight60Second: Robot/20160721_102938RobotArm_left_right_60s_belowsensors
%               23. RobotArmLeftRight60SecondA20S240: Robot/20160721_111702COM5_RobotArm_left_right_60s_belowsensors_A20_S_240
%               24. RobotArmLeftRight60SecondA20S60: Robot/20160721_114531RobotArm_left_right_60s_belowsensors_A20_S_60
%               25. RobotArmLeftRight60SecondA70S60: Robot/20160721_120659RobotArm_left_right_60s_belowsensors_A70_S_60
%               26. RobotArmLeftRight60SecondA20S60Box1: Robot/20160721_132319RobotArm_left_right_60s_A20_S_60_Box1_141cm
%   FanHigh     D:/Philips/Database/Fan/FanHighSpeed_20160912_160535

%% Convert .txt File into .mat File

clear
clc
close all

folder = 'D:/Philips/Database/HumanFan/20170120_twoperson/';
files = dir([folder,'*.txt']);

for i = 1:length(files)
    % fid = fopen('D:/Philips/Database/HumanFan/20160831_165421_walking_in_the_room_with_fan/COM5_walking_in_the_room_with_fan_20160831_165421.txt');
    % RawData = textscan(fid, '%s%s%s%s%s%s');
    % fclose(fid);
    
    fid = fopen([folder,files(i).name]);
    FileName = files(i).name;
    RawData = textscan(fid, '%s%s%s%s%s%s');
    fclose(fid);
    
    ch0 = strrep(RawData{1,2}, 'ch0=', '');
    ch1 = strrep(RawData{1,3}, 'ch1=', '');
    temp = strrep(RawData{1,4}, 'temp=', '');
    det = strrep(RawData{1,5}, 'det=', '');
    olddet = strrep(RawData{1,6}, 'olddet=', '');
    [~,~,~,Hour,Minute,Second] = datevec(RawData{1,1}, 'HH:MM:SS,FFF');
    
    Ch0 = str2double(ch0);
    Ch1 = str2double(ch1);
    Temp = str2double(temp);
    Det = str2double(det);
    OldDet = str2double(olddet);
    
    Data = table(Hour,Minute,Second,Ch0,Ch1,Temp,Det,OldDet);
    save(FileName(1:end-4),'Data');
end

%% Show Eight Signals of Four Sensors
%
% load('D:\Philips\Database\HumanFan\20160831_165421_walking_in_the_room_with_fan\COM5_walking_in_the_room_with_fan_20160831_165421.mat');
% Data = table2array(Data);
% ReadingTime = Data(:,1)*3600+Data(:,2)*60+Data(:,3);
% COM5Time = ReadingTime-ReadingTime(1);
% COM5Data = Data;
% load('D:\Philips\Database\HumanFan\20160831_165421_walking_in_the_room_with_fan\COM6_walking_in_the_room_with_fan_20160831_165421.mat');
% Data = table2array(Data);
% ReadingTime = Data(:,1)*3600+Data(:,2)*60+Data(:,3);
% COM6Time = ReadingTime-ReadingTime(1);
% COM6Data = Data;
% load('D:\Philips\Database\HumanFan\20160831_165421_walking_in_the_room_with_fan\COM7_walking_in_the_room_with_fan_20160831_165421.mat');
% Data = table2array(Data);
% ReadingTime = Data(:,1)*3600+Data(:,2)*60+Data(:,3);
% COM7Time = ReadingTime-ReadingTime(1);
% COM7Data = Data;
% load('D:\Philips\Database\HumanFan\20160831_165421_walking_in_the_room_with_fan\COM8_walking_in_the_room_with_fan_20160831_165421.mat');
% Data = table2array(Data);
% ReadingTime = Data(:,1)*3600+Data(:,2)*60+Data(:,3);
% COM8Time = ReadingTime-ReadingTime(1);
% COM8Data = Data;
% minSignal = min([min(COM5Data(:,4)),min(COM5Data(:,5)),min(COM6Data(:,4)),min(COM6Data(:,5)),min(COM7Data(:,4)),min(COM7Data(:,5)),min(COM8Data(:,4)),min(COM8Data(:,5))]);
% maxSignal = min([max(COM5Data(:,4)),max(COM5Data(:,5)),max(COM6Data(:,4)),max(COM6Data(:,5)),max(COM7Data(:,4)),max(COM7Data(:,5)),max(COM8Data(:,4)),max(COM8Data(:,5))]);
% maxTime = max([max(COM5Time),max(COM6Time),max(COM7Time),max(COM8Time)]);
%
% % Hour = Data(:,1);
% % Minute = Data(:,2);
% % Second = Data(:,3);
% % Ch0 = Data(:,4);
% % Ch1 = Data(:,5);
% % Temp = Data(:,6);
% % Det = Data(:,7);
% % OldDet = Data(:,8);
%
% figure;
% subplot(4,2,1);
% plot(COM5Time,COM5Data(:,4));
% axis([0 maxTime minSignal maxSignal]);
% xlabel('time (second)');
% ylabel('COM5Ch0');
% subplot(4,2,2);
% plot(COM5Time,COM5Data(:,5));
% axis([0 maxTime minSignal maxSignal]);
% xlabel('time (second)');
% ylabel('COM5Ch1');
% subplot(4,2,3);
% plot(COM6Time,COM6Data(:,4));
% axis([0 maxTime minSignal maxSignal]);
% xlabel('time (second)');
% ylabel('COM6Ch0');
% subplot(4,2,4);
% plot(COM6Time,COM6Data(:,5));
% axis([0 maxTime minSignal maxSignal]);
% xlabel('time (second)');
% ylabel('COM6Ch1');
% subplot(4,2,5);
% plot(COM7Time,COM7Data(:,4));
% axis([0 maxTime minSignal maxSignal]);
% xlabel('time (second)');
% ylabel('COM7Ch0');
% subplot(4,2,6);
% plot(COM7Time,COM7Data(:,5));
% axis([0 maxTime minSignal maxSignal]);
% xlabel('time (second)');
% ylabel('COM7Ch1');
% subplot(4,2,7);
% plot(COM8Time,COM8Data(:,4));
% axis([0 maxTime minSignal maxSignal]);
% xlabel('time (second)');
% ylabel('COM8Ch0');
% subplot(4,2,8);
% plot(COM8Time,COM8Data(:,5));
% axis([0 maxTime minSignal maxSignal]);
% xlabel('time (second)');
% ylabel('COM8Ch1');
% suptitle('GeorgesWalkInOutWithFan');
