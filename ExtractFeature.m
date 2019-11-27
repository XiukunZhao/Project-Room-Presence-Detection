% This file is used to extract features for each moving window
% Input: Signal data and activity label
% Output: 17 dimensional feature base

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

load('D:/Philips/Database/HumanFan/20160831_165421_walking_in_the_room_with_fan/COM6_walking_in_the_room_with_fan_20160831_165421.mat');
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

load('HumanFanMotionMatrixSmallArea.mat');
load('HumanFanActivityLabel.mat');
tit_str = 'HumanFanFeature';

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

%% Initialization

AlignedCh0 = Ch0(SignalLabelStart:SignalLabelEnd);
IntegerCh0 = AlignedCh0(FinalSignalLabel);
AlignedCh1 = Ch1(SignalLabelStart:SignalLabelEnd);
IntegerCh1 = AlignedCh1(FinalSignalLabel);

Freq = 77;
T = 1/Freq;       % Sampling period
windowsize = 10;  % Unit: second
Fwindowsize = 20; % Unit: second
shiftsize = 1;    % Unit: second
SignalLength = length(AlignedCh0);
FrameLength = length(IntegerCh0);
shiftnumber = fix((FrameLength - Fwindowsize)/shiftsize)+1;
EndTime = (shiftnumber-1) * shiftsize + Fwindowsize;  % Total effective time
Features0 = zeros(shiftnumber,17); % 17 dimensional feature of chanel 0
Features1 = zeros(shiftnumber,17); % 17 dimensional feature of chanel 1
p = 0.97;

%% Ch0

WindowStartLabel = windowsize+1;            % Time domain window
WindowEndLabel = WindowStartLabel+windowsize-1;
FWindowStartLabel = 1;                      % Frequency domain window
FWindowEndLabel = FWindowStartLabel+Fwindowsize-1;
for index = 1:shiftnumber
    window = AlignedCh0(FinalSignalLabel(WindowStartLabel):FinalSignalLabel(WindowEndLabel));
    label = Label(WindowEndLabel);
    Fwindow = AlignedCh0(FinalSignalLabel(FWindowStartLabel):FinalSignalLabel(FWindowEndLabel));
    untrendedsinganl = window-mean(window);
    Funtrendedsinganl = Fwindow-mean(Fwindow);
    % highthreshold  = max(Ch0+50-mean(Ch0));      % Make sure there is no peaks in the noise data
    % lowthreshold = -min(Ch0)-50+mean(Ch0);
    highthreshold  = quantile(untrendedsinganl,p);
    lowthreshold = quantile(-untrendedsinganl,p);
    [~,locs,w,pro] = findpeaks(untrendedsinganl,'MINPEAKHEIGHT',highthreshold,'MinPeakDistance',Freq);      % Minimum peaks hight +3sigma  Minimum distance between two peaks 1s
    [~,ilocs,iw,ipro] = findpeaks(-untrendedsinganl,'MINPEAKHEIGHT',lowthreshold,'MinPeakDistance',Freq);   % Minimum peaks hight -3sigma  Minimum distance between two peaks 1s
    FL = length(Fwindow);
    t = (0:FL-1)*T;
    fftY = fft(Funtrendedsinganl);
    E = 2*abs(fftY)/FL;
    E = E(1:FL/2).^2;                    % Take the power of positve freq. half
    P2 = abs(fftY/FL);                   % Double-Sided Spectrum
    P1 = P2(1:FL/2+1);                   % Amplitude of positive frequency
    P1(2:end-1) = 2*P1(2:end-1);         % Single-Sided Spectrum
    freq = Freq*(0:(FL/2))/FL;           % Find the corresponding frequency in Hz
    energy  = sum(E);
    halfenergy  = 0;
    i  = 1;
    fq = quantile(P1(2:end-1),p);
    [~,flocs,fw,fpro] = findpeaks(P1,'MINPEAKHEIGHT',fq);        % Frequency peaks
    while halfenergy < energy / 2                                % Half energy
        halfenergy  = halfenergy + E(i);
        i = i+1;
    end
    halenergyfreq  = freq(i-1);
    WindowStartLabel = WindowStartLabel+shiftsize;
    WindowEndLabel = WindowStartLabel+windowsize-1;
    FWindowStartLabel = FWindowStartLabel+shiftsize;
    FWindowEndLabel = FWindowStartLabel+Fwindowsize-1;
    s11 = size(locs);
    s12 = size(ilocs);
    Features0(index,1) = mean(window);                                       % 01. Window mean
    Features0(index,2) = std(window)/mean(window);                           % 02. Window Variance
    Features0(index,3) = mean(abs(diff(untrendedsinganl)));                  % 03. Variation
    Features0(index,4) = s11(1)+s12(1);                                      % 04. Total number of peaks
    peaklocs  = sort(t(cat(1,locs,ilocs)));
    spnl = size(peaklocs);
    disp(spnl);
    sp = size(locs);
    sn = size(ilocs);
    if sp(1) > 0        % Check if the window has + peacks
        Features0(index,5) = max(untrendedsinganl(locs));                    % 05. Max amplitude of positive peaks
    end
    if sn(1) > 0        % Check if the window has - peacks
        Features0(index,6) =  min(-untrendedsinganl(ilocs));                 % 06. Max amplitude of negative peaks
    end
    if spnl(2) > 1      % Check if the window has more than one peacks
        Features0(index,7) = mean(diff(peaklocs));                           % 07. Average of distances between two successive peaks
        Features0(index,8) = std(diff(peaklocs))/mean(diff(peaklocs));       % 08. Coefficient of variation of peak distances
    end
    if sp(1) > 0
        Features0(index,9) = mean(cat(1,w,iw));                              % 09. Average of peak widths
        Features0(index,10) = std(cat(1,w,iw))/mean(cat(1,w,iw));            % 10. Coefficient of variation of peak widths
        Features0(index,11) = (sum(untrendedsinganl(locs).^2)+sum(untrendedsinganl(ilocs).^2))/sum(untrendedsinganl.^2); % 11. Frac of energy stored in peaks
    end
    Features0(index,12) = halenergyfreq;                                             % 12. Half Energy
    Features0(index,13) = i-1;                                                       % 13. Number of frequencies involved in half of Energy (p)
    sl = size(flocs);
    if sl(1) > 0
        Features0(index,14) = max(P1(flocs));                                        % 14. Maximum magnitude
        Features0(index,15) = freq(P1==max(P1(flocs)));                              % 15. Frequency of maximum magnitude (in Hz)
        if sl(1) >1
            Features0(index,16) = mean(diff(freq(flocs)));                           % 16. Average distance between two successive frequencies (in Hz)
            Features0(index,17) = std(diff(freq(flocs)))/mean(diff(freq(flocs)));    % 17. Coefficient of variation of frequency distances
        end
    end
    LabelThreshold = 0.3;
    LabelDecision = sum(label)/length(label);
    Features0(index,18) = label;                                            % 18. Activity
end

%% Ch1

WindowStartLabel = windowsize+1;
WindowEndLabel = WindowStartLabel+windowsize-1;
FWindowStartLabel = 1;
FWindowEndLabel = FWindowStartLabel+Fwindowsize-1;
for index = 1:shiftnumber
    window = AlignedCh1(FinalSignalLabel(WindowStartLabel):FinalSignalLabel(WindowEndLabel));
    label = Label(WindowEndLabel);
    Fwindow = AlignedCh1(FinalSignalLabel(FWindowStartLabel):FinalSignalLabel(FWindowEndLabel));
    untrendedsinganl = window-mean(window);
    Funtrendedsinganl = Fwindow-mean(Fwindow);
    highthreshold  = quantile(untrendedsinganl,p);
    lowthreshold = quantile(-untrendedsinganl,p);
    [~,locs,w,pro] = findpeaks(untrendedsinganl,'MINPEAKHEIGHT',highthreshold,'MinPeakDistance',Freq);      % Minimum peaks hight +3sigma  Minimum distance between two peaks 1s
    [~,ilocs,iw,ipro] = findpeaks(-untrendedsinganl,'MINPEAKHEIGHT',lowthreshold,'MinPeakDistance',Freq);   % Minimum peaks hight -3sigma  Minimum distance between two peaks 1s
    FL = length(Fwindow);
    t = (0:FL-1)*T;
    fftY = fft(Funtrendedsinganl);
    E = 2*abs(fftY)/FL;
    E = E(1:FL/2).^2;                    % Take the power of positve freq. half
    P2 = abs(fftY/FL);                   % Double-Sided Spectrum
    P1 = P2(1:FL/2+1);                   % Amplitude of positive frequency
    P1(2:end-1) = 2*P1(2:end-1);         % Single-Sided Spectrum
    freq = Freq*(0:(FL/2))/FL;           % Find the corresponding frequency in Hz
    energy  = sum(E);
    halfenergy  = 0;
    i  = 1;
    fq = quantile(P1(2:end-1),p);
    [~,flocs,fw,fpro] = findpeaks(P1,'MINPEAKHEIGHT',fq);
    while halfenergy < energy / 2
        halfenergy  = halfenergy + E(i);
        i = i+1;
    end
    halenergyfreq  = freq(i-1);
    WindowStartLabel = WindowStartLabel+shiftsize;
    WindowEndLabel = WindowStartLabel+windowsize-1;
    FWindowStartLabel = FWindowStartLabel+shiftsize;
    FWindowEndLabel = FWindowStartLabel+Fwindowsize-1;
    s11 = size(locs);
    s12 = size(ilocs);
    Features1(index,1) = mean(window);                                       % 01. Window mean
    Features1(index,2) = std(window)/mean(window);                           % 02. Window Variance
    Features1(index,3) = mean(abs(diff(untrendedsinganl)));                  % 03. Variation
    Features1(index,4) = s11(1)+s12(1);                                      % 04. Total number of peaks
    peaklocs  = sort(t(cat(1,locs,ilocs)));
    spnl = size(peaklocs);
    disp(spnl);
    sp = size(locs);
    sn = size(ilocs);
    if sp(1) > 0
        Features1(index,5) = max(untrendedsinganl(locs));                    % 05. Max amplitude of positive peaks
    end
    if sn(1) > 0
        Features1(index,6) =  min(-untrendedsinganl(ilocs));                 % 06. Max amplitude of negative peaks
    end
    if spnl(2) > 1
        Features1(index,7) = mean(diff(peaklocs));                           % 07. Average of distances between two successive peaks
        Features1(index,8) = std(diff(peaklocs))/mean(diff(peaklocs));       % 08. Coefficient of variation of peak distances
    end
    if sp(1) > 0
        Features1(index,9) = mean(cat(1,w,iw));                              % 09. Average of peak widths
        Features1(index,10) = std(cat(1,w,iw))/mean(cat(1,w,iw));            % 10. Coefficient of variation of peak widths
        Features1(index,11) = (sum(untrendedsinganl(locs).^2)+sum(untrendedsinganl(ilocs).^2))/sum(untrendedsinganl.^2); % 11. Frac of energy stored in peaks
    end
    Features1(index,12) = halenergyfreq;                                             % 12. Half Energy
    Features1(index,13) = i-1;                                                       % 13. Number of frequencies involved in half of Energy (p)
    sl = size(flocs);
    if sl(1) > 0
        Features1(index,14) = max(P1(flocs));                                        % 14. Maximum magnitude
        Features1(index,15) = freq(P1==max(P1(flocs)));                              % 15. Frequency of maximum magnitude (in Hz)
        if sl(1) >1
            Features1(index,16) = mean(diff(freq(flocs)));                           % 16. Average distance between two successive frequencies (in Hz)
            Features1(index,17) = std(diff(freq(flocs)))/mean(diff(freq(flocs)));    % 17. Coefficient of variation of frequency distances
        end
    end
    LabelThreshold = 0.3;
    LabelDecision = sum(label)/length(label);
    Features1(index,18) = label;                                                     % 18. Activity
end

Features = [Features0;Features1];

%% Feature Table

save(tit_str, 'Features0', 'Features1');

Feature0 = array2table(Features0,'VariableNames',{'Mean','Variance','Variation','PeakNo', 'MaxAmplitude','MinAmplitude', 'DistanceTwoPeaks','SDDistance',...
    'PeakWidth','SDPeakWidth','TotalEnergy','HalfEnergy','FreqNoHalfEnergy','MaxMagnitude','FrequncyMaxMagnitude','FreqDistanceTwoPeaks','FreqSDDistance','Activity'});

Feature1 = array2table(Features1,'VariableNames',{'Mean','Variance','Variation','PeakNo', 'MaxAmplitude','MinAmplitude', 'DistanceTwoPeaks','SDDistance',...
    'PeakWidth','SDPeakWidth','TotalEnergy','HalfEnergy','FreqNoHalfEnergy','MaxMagnitude','FrequncyMaxMagnitude','FreqDistanceTwoPeaks','FreqSDDistance','Activity'});

Feature = array2table(Features,'VariableNames',{'Mean','Variance','Variation','PeakNo', 'MaxAmplitude','MinAmplitude', 'DistanceTwoPeaks','SDDistance',...
    'PeakWidth','SDPeakWidth','TotalEnergy','HalfEnergy','FreqNoHalfEnergy','MaxMagnitude','FrequncyMaxMagnitude','FreqDistanceTwoPeaks','FreqSDDistance','Activity'});

writetable(Feature0,'HumanFanCOM6.xlsx','Sheet',1);
writetable(Feature1,'HumanFanCOM6.xlsx','Sheet',2);
writetable(Feature,'HumanFanCOM6.xlsx','Sheet',3);

% %% Signal Plot
%
% figure;
% ReadingTime = Hour(SignalLabelStart:SignalLabelEnd)*3600+Minute(SignalLabelStart:SignalLabelEnd)*60+Second(SignalLabelStart:SignalLabelEnd);
% Time = ReadingTime-ReadingTime(1);
% plot(Time, AlignedCh0(SignalLabelStart:SignalLabelEnd));
% title('COM5 Ch0');
% xlabel('time (second)');
% ylabel('signal');
%
% figure;
% stem(Features0(241:300,1));
% title('Feature 1 (mean)');
% xlabel('window');
% ylabel('feature');
% ylim([7500 8500]);
%
% figure;
% stem(Features0(241:300,2));
% title('Feature 2 (variance)');
% xlabel('window');
% ylabel('feature');
%
% figure;
% stem(Features0(241:300,3));
% title('Feature 3 (variation)');
% xlabel('window');
% ylabel('feature');
%
% figure;
% stem(Features0(241:300,4));
% title('Feature 4 (number of peaks)');
% xlabel('window');
% ylabel('feature');
%
% figure;
% stem(Features0(241:300,5));
% title('Feature 5 (max amplitude)');
% xlabel('window');
% ylabel('feature');
%
% figure;
% stem(Features0(241:300,6));
% title('Feature 6 (min amplitude)');
% xlabel('window');
% ylabel('feature');
%
% figure;
% stem(Features0(241:300,7));
% title('Feature 7 (average of distances)');
% xlabel('window');
% ylabel('feature');
%
% figure;
% stem(Features0(241:300,8));
% title('Feature 8 (SD of distances)');
% xlabel('window');
% ylabel('feature');
%
% figure;
% stem(Features0(241:300,9));
% title('Feature 9 (average of peak widths)');
% xlabel('window');
% ylabel('feature');
%
% figure;
% stem(Features0(241:300,10));
% title('Feature 10 (SD of peak widths)');
% xlabel('window');
% ylabel('feature');
%
% figure;
% stem(Features0(241:300,11));
% title('Feature 11 (total energy in peaks)');
% xlabel('window');
% ylabel('feature');
%
% figure;
% stem(Features0(241:300,12));
% title('Feature 12 (half energy)');
% xlabel('window');
% ylabel('feature');
%
% figure;
% stem(Features0(241:300,13));
% title('Feature 13 (number of frequencies in half energy)');
% xlabel('window');
% ylabel('feature');
%
% figure;
% stem(Features0(241:300,14));
% title('Feature 14 (max magnitude)');
% xlabel('window');
% ylabel('feature');
%
% figure;
% stem(Features0(241:300,15));
% title('Feature 15 (frequency of max magnitude)');
% xlabel('window');
% ylabel('feature');
%
% figure;
% stem(Features0(241:300,16));
% title('Feature 16 (average of distances between two peaks)');
% xlabel('window');
% ylabel('feature');
%
% figure;
% stem(Features0(241:300,17));
% title('Feature 17 (SD of distances)');
% xlabel('window');
% ylabel('feature');
