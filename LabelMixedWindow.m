% This file is used to label activity level for mixed moving windows
% Input: Average eigenvalues per window
% Output: Threshold values of different activity levels

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Database used to set threshold values consisting of
% HumanFan Activity: 1. GeorgesWalkInOutWithFan: HumanFan/Video20160831_165421_walking_in_the_room_with_fan
%                       HumanFan/20160831_165421_walking_in_the_room_with_fan/COM5_walking_in_the_room_with_fan_20160831_165421.mat
%                    2. TwoPersonActiveWithFan: HumanFan/Video20170120_twoperson
%                        HumanFan/20170120_twoperson/COM5_Actilume_raw_data_20170120_161603.mat
% Human Activity: 3. MajaSitStand40Second: Human/20160517_131445_Video_SittingStandingBelowSensors_Maja_trial1_40sec_30min
%                    Human/20160517_131445_SittingStandingBelowSensors_Maja_trial1_40sec_30min/COM5_SittingStandingBelowSensors_Maja_trial1_40sec_20160517_131445.mat
%                 4. GeorgesWalkInOutWithoutFan: Human/Video20160831_163913_walking_in_the_room_without_fan
%                    Human/20160831_163913_walking_in_the_room_without_fan/COM5_walking_in_the_room_without_fan_20160831_163913.mat
%                 5. TwoPersonActiveWithoutFan: Human/Video_FanOffPersonActiveIntheRoom_20160912_171415
%                    Human/FanOffPersonActiveIntheRoom_20160912_171415/COM5_FanOffPersonActiveIntheRoom_20160912_171415.mat
% RobotActivity:  6. RobotArmUpDown40Second: Robot/Video_20160526_140448RobotArmBelowSensors_40sup_40sdown
%                    Robot/20160526_140448RobotArmBelowSensors_40sup_40sdown/COM5_RobotArmBelowSensors_40sup_40sdown_20160526_140448.mat

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear;
clc;
close all;

%% Load Average Eigenvalues of Each Window

load('GeorgesWalkInOutWithFanEigenMean.mat');
WindowEigA = WindowEigen;
load('TwoPersonActiveWithFanEigenMean.mat');
WindowEigB = WindowEigen;
load('MajaSitStand40SecondEigenMean.mat');
WindowEigC = WindowEigen;
load('GeorgesWalkInOutWithoutFanEigenMean.mat');
WindowEigD = WindowEigen;
load('TwoPersonActiveWithoutFanEigenMean.mat');
WindowEigE = WindowEigen;
load('RobotArmUpDown40SecondEigenMean.mat');
WindowEigF = WindowEigen;

%% Normalize Average Eigenvalues

WindowEig = [WindowEigA;WindowEigB;WindowEigC;WindowEigD;WindowEigE;WindowEigF];
MaxFirstEigen = max(WindowEig(:,1));
MaxSecondEigen = max(WindowEig(:,2));
MaxThirdEigen = max(WindowEig(:,3));
NorWindowEig(:,1) = WindowEig(:,1)/MaxFirstEigen;
NorWindowEig(:,2) = WindowEig(:,2)/MaxSecondEigen;
NorWindowEig(:,3) = WindowEig(:,3)/MaxThirdEigen;

%% Clustering with Four Levels

matrix3 = NorWindowEig(:,1:3);
[cidx3, ctrs3] = kmeans(matrix3, 4);

figure;                     % Clustering with three eigenvalues
plot3(matrix3(cidx3==1,1),matrix3(cidx3==1,2),matrix3(cidx3==1,3),'ro');
hold on ;
plot3(matrix3(cidx3==2,1),matrix3(cidx3==2,2),matrix3(cidx3==2,3),'bo');
hold on ;
plot3(matrix3(cidx3==3,1),matrix3(cidx3==3,2),matrix3(cidx3==3,3),'go');
hold on ;
plot3(matrix3(cidx3==4,1),matrix3(cidx3==4,2),matrix3(cidx3==4,3),'yo');
hold on ;
plot3(ctrs3(:,1),ctrs3(:,2),ctrs3(:,3),'kx');
grid on
legend('Cluster 1','Cluster 2','Cluster 3','Cluster 4','Centroids','Location','NW');
title('Activity Level Clusters');
xlabel('first largest eigenvalue');
ylabel('second largest eigenvalue');
zlabel('third largest eigenvalue');
hold off

matrix2 = NorWindowEig(:,1:2);
[cidx2, ctrs2] = kmeans(matrix2,4);

figure;                      % Clustering with two eigenvalues
plot(matrix2(cidx2==1,1),matrix2(cidx2==1,2),'r.','MarkerSize',12);
hold on
plot(matrix2(cidx2==2,1),matrix2(cidx2==2,2),'b.','MarkerSize',12);
hold on
plot(matrix2(cidx2==3,1),matrix2(cidx2==3,2),'g.','MarkerSize',12);
hold on
plot(matrix2(cidx2==4,1),matrix2(cidx2==4,2),'y.','MarkerSize',12);
plot(ctrs2(:,1),ctrs2(:,2),'kx','MarkerSize',15,'LineWidth',3);
legend('Cluster 1','Cluster 2','Cluster 3','Cluster 4','Centroids','Location','NW');
title('Activity Level Clusters');
xlabel('first largest eigenvalue');
ylabel('second largest eigenvalue');
hold off

% figure;                    % Histogram shows the number of data in each cluster
% [counts, binValues] = hist(cidx3, 4);
% bar(binValues, counts, 'barwidth', 1);

% %% Adjust Clusters
%
% SetValue = sort(ctrs3,1);
% MaxThreshold = [mean([0,SetValue(1,1)]),mean([SetValue(1,1),SetValue(2,1)]),mean([SetValue(3,1),SetValue(2,1)]),mean([SetValue(3,1),SetValue(4,1)])];
% SecondThreshold = [mean([0,SetValue(1,2)]),mean([SetValue(1,2),SetValue(2,2)]),mean([SetValue(3,2),SetValue(2,2)]),mean([SetValue(3,2),SetValue(4,2)])];
% ThirdThreshold = [mean([0,SetValue(1,3)]),mean([SetValue(1,3),SetValue(2,3)]),mean([SetValue(3,3),SetValue(2,3)]),mean([SetValue(3,3),SetValue(4,3)])];
% TotalNumber = length(WindowEig);
%
% for i = 1:TotalNumber
%     for j = 1:4
%     Dist(i,j)=(NorWindowEig(i,1)-MaxThreshold(j))^2+(NorWindowEig(i,2)-SecondThreshold(j))^2+(NorWindowEig(i,3)-ThirdThreshold(j))^2;
%     end
%     Id(i)=(find(Dist(i,1:4)==min(Dist(i,1:4))));
% end
%
% figure;
% plot3(matrix3(Id==1,1),matrix3(Id==1,2),matrix3(Id==1,3),'ro');
% hold on ; plot3(matrix3(Id==2,1),matrix3(Id==2,2),matrix3(Id==2,3),'bo');
% hold on ; plot3(matrix3(Id==3,1),matrix3(Id==3,2),matrix3(Id==3,3),'go');
% hold on ; plot3(matrix3(Id==4,1),matrix3(Id==4,2),matrix3(Id==4,3),'yo');
% grid on
% legend('Cluster 1','Cluster 2','Cluster 3','Cluster 4','Centroids','Location','NW');
% title('Activity Clusters');
% xlabel('first largest eigenvalue');
% ylabel('second largest eigenvalue');
% zlabel('third largest eigenvalue');
% hold off
%
% figure;
% [counts, binValues] = hist(Id, 4);
% bar(binValues, counts, 'barwidth', 1);
%
% eva = evalclusters(NorWindowEig,'kmeans','CalinskiHarabasz','KList',[1:7]);

%% Random Samples for Clustering

TotalNumber = length(WindowEig);
WindowSampleId = randsample(TotalNumber,TotalNumber*0.6);
matrix3Sample = NorWindowEig(WindowSampleId,:);
[Scidx, Sctrs] = kmeans(matrix3Sample, 4);

figure;
plot3(matrix3Sample(Scidx==1,1),matrix3Sample(Scidx==1,2),matrix3Sample(Scidx==1,3),'ro');
hold on ;
plot3(matrix3Sample(Scidx==2,1),matrix3Sample(Scidx==2,2),matrix3Sample(Scidx==2,3),'bo');
hold on ;
plot3(matrix3Sample(Scidx==3,1),matrix3Sample(Scidx==3,2),matrix3Sample(Scidx==3,3),'go');
hold on ;
plot3(matrix3Sample(Scidx==4,1),matrix3Sample(Scidx==4,2),matrix3Sample(Scidx==4,3),'yo');
hold on ;
plot3(Sctrs(:,1),Sctrs(:,2),Sctrs(:,3),'kx');
grid on
legend('Cluster 1','Cluster 2','Cluster 3','Cluster 4','Centroids','Location','NW');
title('Activity Level Clusters (random samples)');
xlabel('first largest eigenvalue');
ylabel('second largest eigenvalue');
zlabel('third largest eigenvalue');
hold off

%% Check Accuracy of Clustering Algorithm

Dist = zeros(TotalNumber,4);
Id = zeros(1,TotalNumber);
DistSample = zeros(TotalNumber,4);
IdSample = zeros(1,TotalNumber);

SetValue = sort(ctrs3,1);
for i = 1:TotalNumber
    for j = 1:4
        Dist(i,j)=(NorWindowEig(i,1)-SetValue(j,1))^2+(NorWindowEig(i,2)-SetValue(j,2))^2+(NorWindowEig(i,3)-SetValue(j,3))^2;
    end
    Id(i)=(find(Dist(i,1:4) == min(Dist(i,1:4))));
end

SetValueSample = sort(Sctrs,1);
for i = 1:TotalNumber
    for j = 1:4
        DistSample(i,j)=(NorWindowEig(i,1)-SetValueSample(j,1))^2+(NorWindowEig(i,2)-SetValueSample(j,2))^2+(NorWindowEig(i,3)-SetValueSample(j,3))^2;
    end
    IdSample(i)=(find(DistSample(i,1:4) == min(DistSample(i,1:4))));
end

Accuracy = 1-length(find(Id~=IdSample))/TotalNumber;

% save Threshold SetValue MaxFirstEigen MaxSecondEigen MaxThirdEigen
