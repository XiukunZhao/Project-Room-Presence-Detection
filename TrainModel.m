% This file is used to train predictive models (also need use the APP
% Classification Learner to produce trainedClassifier1, trainedClassifier2,
% trainedClassifier3, trainedClassifier4)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% clear;
% clc;
% close all;

%% Load Data

Data1 = xlsread('GeorgesWalkInOutWithoutFanCOM5.xlsx',1);
Data2 = xlsread('TwoPersonsActiveInRoomCOM5.xlsx',1);
Data3 = xlsread('HumanFanCOM5.xlsx',1);
Data4 = xlsread('HumanFanTwoPersonCOM5.xlsx',1);
Data5 = xlsread('MajaSitStand40SecondCOM5.xlsx',1);
Data6 = xlsread('RobotArmUpDown40SecondCOM5.xlsx',1);

Data = [Data1;Data2;Data3;Data4;Data5;Data6];
DataTable = array2table(Data,'VariableNames',{'Mean','Variance','Variation','PeakNo', 'MaxAmplitude','MinAmplitude', 'DistanceTwoPeaks','SDDistance',...
    'PeakWidth','SDPeakWidth','TotalEnergy','HalfEnergy','FreqNoHalfEnergy','MaxMagnitude','FrequncyMaxMagnitude','FreqDistanceTwoPeaks','FreqSDDistance','Activity'});
m = length(Data);
[trainInd,valInd,testInd] = dividerand(m,0.75,0,0.25);
TrainData = Data(trainInd,:);
TestData = Data(testInd,:);
TrainDataTable = array2table(TrainData,'VariableNames',{'Mean','Variance','Variation','PeakNo', 'MaxAmplitude','MinAmplitude', 'DistanceTwoPeaks','SDDistance',...
    'PeakWidth','SDPeakWidth','TotalEnergy','HalfEnergy','FreqNoHalfEnergy','MaxMagnitude','FrequncyMaxMagnitude','FreqDistanceTwoPeaks','FreqSDDistance','Activity'});
TestDataTable = array2table(TestData,'VariableNames',{'Mean','Variance','Variation','PeakNo', 'MaxAmplitude','MinAmplitude', 'DistanceTwoPeaks','SDDistance',...
    'PeakWidth','SDPeakWidth','TotalEnergy','HalfEnergy','FreqNoHalfEnergy','MaxMagnitude','FrequncyMaxMagnitude','FreqDistanceTwoPeaks','FreqSDDistance','Activity'});

NormlizedData = Data;
for i = 1:17
    NormlizedData(:,i) = Data(:,i)/max(Data(:,i));
end
NorDataTable = array2table(NormlizedData,'VariableNames',{'Mean','Variance','Variation','PeakNo', 'MaxAmplitude','MinAmplitude', 'DistanceTwoPeaks','SDDistance',...
    'PeakWidth','SDPeakWidth','TotalEnergy','HalfEnergy','FreqNoHalfEnergy','MaxMagnitude','FrequncyMaxMagnitude','FreqDistanceTwoPeaks','FreqSDDistance','Activity'});

Sample = NormlizedData(300:700,:);
SampleTable = array2table(Sample,'VariableNames',{'Mean','Variance','Variation','PeakNo', 'MaxAmplitude','MinAmplitude', 'DistanceTwoPeaks','SDDistance',...
    'PeakWidth','SDPeakWidth','TotalEnergy','HalfEnergy','FreqNoHalfEnergy','MaxMagnitude','FrequncyMaxMagnitude','FreqDistanceTwoPeaks','FreqSDDistance','Activity'});

DataCOM6 = xlsread('HumanFanCOM6.xlsx',1);
DataTable6 = array2table(DataCOM6,'VariableNames',{'Mean','Variance','Variation','PeakNo', 'MaxAmplitude','MinAmplitude', 'DistanceTwoPeaks','SDDistance',...
    'PeakWidth','SDPeakWidth','TotalEnergy','HalfEnergy','FreqNoHalfEnergy','MaxMagnitude','FrequncyMaxMagnitude','FreqDistanceTwoPeaks','FreqSDDistance','Activity'});

% %% Model 1: Decision Tree  % fitctree()
%
% view(trainedClassifier1.ClassificationTree,'Mode','graph');
% figure;
% Importance = predictorImportance(trainedClassifier.ClassificationTree);
% bar(Importance);
% title('Predictor Importance Estimates');
% ylabel('Estimates');
% xlabel('Predictors');
% h = gca;
% h.XTickLabel = trainedClassifier1.ClassificationTree.PredictorNames;
% h.XTickLabelRotation = 45;
% h.TickLabelInterpreter = 'none';
% orderedImportance = sort(Importance);
%
% yfit1 = trainedClassifier1.predictFcn(DataTable);   % Predicted values
% save yfit1 yfit1
%
% %% Model 2: Quadratic SVM (Support Vector Machine)  % fitcsvm()
%
% % X = Data(:,1:17);
% % Y = Data(:,18);
% %
% % figure
% % gscatter(X(:,2),X(:,5),Y);
% % h = gca;
% % lims = [h.XLim h.YLim]; % Extract the x and y axis limits
% % title('{\bf Scatter Diagram of Features}');
% % xlabel('Variance');
% % ylabel('Maximal Amplitude');
% % legend('Location','Northwest');
% %
% % Y = num2cell(Y);
% % SVMModels = cell(4,1);
% % classes = unique(Y);
% % rng(1); % For reproducibility
% %
% % for j = 1:numel(classes);
% %     indx = strcmp(Y,classes(j)); % Create binary classes for each classifier
% %     SVMModels{j} = fitcsvm([X(:,2),X(:,5)],indx,'ClassNames',[false true],'Standardize',true,...
% %         'KernelFunction','rbf','BoxConstraint',1);
% % end
% % d = 0.02;
% % [x1Grid,x2Grid] = meshgrid(min(X(:,2)):d:max(X(:,2)),...
% %     min(X(:,5)):d:max(X(:,5)));
% % xGrid = [x1Grid(:),x2Grid(:)];
% % N = size(xGrid,1);
% % Scores = zeros(N,numel(classes));
% %
% % for j = 1:numel(classes);
% %     [~,score] = predict(SVMModels{j},xGrid);
% %     Scores(:,j) = score(:,2); % Second column contains positive-class scores
% % end
% % view(trainedClassifier2.ClassificationSVM,'Mode','graph');
% % predictorImportance(trainedClassifier2.ClassificationSVM);
%
% yfit2 = trainedClassifier2.predictFcn(DataTable); % Predicted values
% save yfit2 yfit2
%
% %% Model 3: Random Forest  % TreeBagger()
%
% view(trainedClassifier.ClassificationEnsemble.Trained{3},'Mode','graph');
% Importance = predictorImportance(trainedClassifier.ClassificationEnsemble.Trained{3});
% yfit3 = trainedClassifier3.predictFcn(DataTable); % Predicted values
% bar(Importance);
% title('Predictor Importance Estimates');
% ylabel('Estimates');
% xlabel('Predictors');
% h = gca;
% h.XTickLabel = trainedClassifier3.ClassificationEnsemble.PredictorNames;
% h.XTickLabelRotation = 45;
% h.TickLabelInterpreter = 'none';
% orderedImportance = sort(Importance);
% save yfit3 yfit3
%
% %% Model 4: Neural Network (Input /Output)
%
% X = Data(:,1:17);
% Input = X';
% Y = Data(:,18)+1;
% Output = zeros(length(unique(Y)),length(X));
% for i = 1:length(X)
% Output(Y(i),i)=1;
% end
%
% % load('TrainSet.mat');
% % load('TestSet.mat');
%
% % figure;
% % stem(TFeature0.Activity);
% % hold on;
% % stem(yfit);
% %  hold on;

%% Confusion Matrix

% yfit = trainedClassifier1.predictFcn(TestDataTable);
% [C,order] = confusionmat(TestData(:,18),yfit);
% CM= zeros(4,4);
% for i =1:4
% CM(i,:) = C(i,:)/sum(C(i,:));
% end
% Accuracy=(CM(1,1)+CM(2,2)+CM(3,3)+CM(4,4))/4;
