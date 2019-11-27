allfiles  = 'D:\Users\randriaf\Philips_george\georges_code\Data\*.csv';
folder  = 'D:\Users\randriaf\Philips_george\georges_code\Data\';
files = dir(allfiles);
for k = 1:length(files)
    disp(files(k).name);
end
experience_name = {};
for i = 1:length(files)
    [token,remain] = strtok(files(i).name, '_');
    experience_name{end+1}  = remain;
end
experience_name = unique(experience_name);
IndexExp = [];
for i=1:length(experience_name)
    IndexExp = [IndexExp i];
end
dictEx = containers.Map(experience_name, IndexExp);
dictSens = containers.Map({'COM5','COM6','COM7','COM8'}, [1,2,3,4]);
data = cell(length(experience_name),4);
label = cell(length(experience_name),4);
for i = 1:length(files)
    disp(i);
    [token,remain] = strtok(files(i).name, '_');
    indexExp = dictEx(remain);
    indexSens = dictSens(token);
    f1 = dlmread(fullfile(folder,files(i).name ));
    data{indexExp,indexSens} = f1;
    if ~isempty(strfind(files(i).name,'Robo'))
        if ~isempty(strfind(files(i).name,'sup'))
            label{indexExp,indexSens} = 1;
        elseif ~isempty(strfind(files(i).name,'_left_right_'))
            label{indexExp,indexSens} = 2;
        elseif ~isempty(strfind(files(i).name,'NonSystematic_'))
            label{indexExp,indexSens} = 3;
        end
    elseif ~isempty(strfind(files(i).name,'_Empty_Room_10_'))
        label{indexExp,indexSens} = 0;
    elseif ~isempty(strfind(files(i).name,'_Maja_left_right_')) 
        label{indexExp,indexSens} = 5;
    elseif ~isempty(strfind(files(i).name,'_SittingStandingBelowSensors'))
        label{indexExp,indexSens} = 4;
    end
        
end