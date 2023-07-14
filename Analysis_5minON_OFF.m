function [idx, NewD] = Analysis_5minON_OFF(k, flist)
NewD = flist(k).name; %
FileName = flist(k).name;
idx = strfind(FileName, '.txt');
if ~isempty(idx)
else
    cd(NewD)
    Files=dir(fullfile('*.mat'));
    for j = 1:numel(Files)
        load(Files(j).name);
        Name = erase(Files(j).name , ".mat");
        Name = erase(Name, "_");
        %create variables using folder name + what it is and use
        %the corresponding table columns to fill it
        assignin("base", strcat(Name, "_Time_LP"), Timestamps.Press{1,1});
        assignin("base", strcat(Name, "_Time_HE"), Timestamps.HeadEntry{1,1});
        assignin("base", strcat(Name, "_Time_Rw"), Timestamps.Reward{1,1});
        assignin("base", strcat(Name, "_LP_END"), Timestamps.EndPress{1,1});
        
        Time_LP = Timestamps.Press{1,1};
        
        FirstNOSTIM_LP= Time_LP(0 <= Time_LP & Time_LP<=300);
        SecondNOSTIM_LP= Time_LP(600 <= Time_LP & Time_LP<=900);
        ThirdNOSTIM_LP= Time_LP(1200 <= Time_LP & Time_LP<=1500);


        NOSTIM_TimeLP = vertcat(FirstNOSTIM_LP, SecondNOSTIM_LP, ThirdNOSTIM_LP);
        assignin("base", strcat(Name, "_NOSTIM_Time_LP"), NOSTIM_TimeLP);
        FirstSTIM_LP= Time_LP(300 <= Time_LP & Time_LP<=600);
        SecondSTIM_LP= Time_LP(900 <= Time_LP & Time_LP<=1200);
        ThirdSTIM_LP= Time_LP(1500 <= Time_LP & Time_LP<=1800);


        STIM_TimeLP = vertcat(FirstSTIM_LP, SecondSTIM_LP, ThirdSTIM_LP);
        assignin("base", strcat(Name, "_STIM_Time_LP"), STIM_TimeLP);
    end
end
