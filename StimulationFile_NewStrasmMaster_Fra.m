%Start by being in the directory with that contains all the folder for the
%stimulation experiments
D=dir;
D = D(~ismember({D.name}, {'.', '..'}));
%this loop will extract all the sessions from the .txt file,
for i = 1:numel(D)
    currD = D(i).name;
    flist = dir(currD);
    flist = flist(~ismember({flist.name}, {'.', '..'}));
    cd(currD)
    for k = 1:numel(flist)
        FileName = flist(k).name;
        idx = strfind(FileName, '.txt');
        if ~isempty(idx)
            MedPC_analysis_NewStream_Fra(FileName)
        else
        end
    end
    cd('..')
end
%%
%Here we start working on every session file to extract and elaborate the variables


for i=1:numel(D)
    currD = D(i).name;
    flist = dir(currD);
    flist = flist(~ismember({flist.name}, {'.', '..'}));
    cd(currD)
    NewD = [];
    for k = 1:numel(flist)
        disp( strcat('folder', '_', currD)) %display the folder name to see what are the 2 frequencies
        if isempty(NewD)
            prompt = 'Is this a 5min ON-OFF session? Y/N:';
            str = input(prompt, 's');
            if str == 'N'
                
                prompt = 'What is Frequency 1?';
                Input1 = input(prompt, 's');
                prompt = 'What is Frequency 2?';
                Input2 = input(prompt, 's');
                
            else
            end
        else
        end
              
                if str == 'N'
                    [idx, NewD] = Analysis_2Stim_Frequencies(k, flist, Input1, Input2);
                else
                    [idx, NewD] = Analysis_5minON_OFF(k, flist);
                end
                    
                    if ~isempty(idx)
                        if k == numel(flist)
                            cd('..')
                        else
                        end
                    else
                        
                        cd('..')
                    end
                    
                end
                save ([D(1).folder '\' currD '.mat'])
                clearvars -except D currD flist Files NewD Input1 Input2
            end

