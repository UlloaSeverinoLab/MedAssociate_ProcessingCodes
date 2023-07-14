% This is the main script for MedPC result analysis. It cites the function
% importfile.m to directly read the MedPC text result.

% NOTICE:

% 1. The Matlab directory should be set to where this script and
% importfile.m are. (It doesn't matter where the MedPC file is.)

% 2. The text result from MedPC ONLY has the session for analysis. And
% there is NO BLANK ROW at the beginning of the file. If you have a
% different way of saving your MedPC result, then you might want to modify
% the script accordingly.

% 3. Before running this script, you need to input the following parameters: session_length_T, c_lastrow.
% Please read the notes in the first section of the scripts for details.

% 4. This script is written for a MedPC script, in which the C array has
% 0.10 for LP, 0.50 for HE, and 0.20 for rewards. If your C array is set
% differently, please change the range accordingly (line 68-70).
% 5. Currently, the Excel result output folder is set to be the same folder where the MedPC
% result is. But you can modify this based on your needs.

% 6. Currently, this script is set to output timestamps in sec, and the
% bin size for bined LP, HE or rewards is a minute. You can modify this
% according to your own needs

% QY 12/06/2017

%% Defind data properties
clear all
directoryname = uigetdir(''); %Select the path containing the file to analyze
filename = uigetfile(directoryname, 'Box3');
file_path = [directoryname '\' filename];
session_length_T = 360000; % T value from MedPC result (unit = 10 ms) 30min180000 / 60min360000 / 120min720000
c_lastrow = 1245; % the number at the last row of the C array.
c_rownumber = c_lastrow/5 + 1;
% get_d = 1; % 1 for get d array (for lever duration), 0 for not.
% d_lastrow = 245; % % the number at the last row of the D array.
outputfile='Box3_cArray.xlsx';
%% Import data

c_original = importfile(file_path, 35, 34+c_rownumber); %for all file without a D_array
%c_original = importfile(file_path, 34, 33+c_rownumber); %for OMISSION files
c = reshape(c_original',[],1);
c_EndIndex = find(isnan(c),1);
if ~isempty(c_EndIndex)
    c = c(1:c_EndIndex-1);
end

%% Get data for LP, HE and Reward

g=c-floor(c);
c(find(g<0.09))=[];

% Find the type of response for each C
e=c-floor(c);
c_sec = floor(c)/1000;
whereLP=e>0.09 & e<0.11;
whereLPEND=e>0.14 & e<0.16;
whereHE=e>0.49 & e<0.51;
whereRew=e>0.19 & e<0.21;

timeLP=c_sec(whereLP);
timeHE=c_sec(whereHE);
timeRew=c_sec(whereRew);
timeLPEnd=c_sec(whereLPEND);
DeltaT_LP= timeLP(2:end)-timeLP(1:end-1);
DeltaT_HE= timeHE(2:end)-timeHE(1:end-1);
DeltaT_Rew= timeRew(2:end)-timeRew(1:end-1);

%% Bin results in min

cum_c=c_sec/60;
num_min=ceil(session_length_T/100/60);
for k=1:num_min
    window=find((cum_c>(k-1)) & (cum_c<=k));
    LPpermin(k)=sum(whereLP(window));
    HEpermin(k)=sum(whereHE(window));
    Rewpermin(k)=sum(whereRew(window));
end
LPpermin = LPpermin';
HEpermin = HEpermin';
Rewpermin = Rewpermin';
if length(timeLP)==length(timeLPEnd)
LPduration = timeLPEnd(1:end) - timeLP(1:end);
else
    LPduration = timeLPEnd(1:end) - timeLP(1:end-1);
end
%% Output to Excel

% output timestamp in sec
timeLP_output = xlswrite([directoryname '\'  outputfile],timeLP,strcat(1,'Time_LP'));
timeHE_output = xlswrite([directoryname '\'  outputfile],timeHE,strcat(1,'Time_HE'));
timeRew_output = xlswrite([directoryname '\'  outputfile],timeRew,strcat(1,'Time_Rew'));
LPduration_output = xlswrite([directoryname '\'  outputfile],LPduration,strcat(1,'LP_duration'));
DeltaT_LP_output = xlswrite([directoryname '\'  outputfile],DeltaT_LP,strcat(1,'DeltaT_LP'));
DeltaT_HE_output = xlswrite([directoryname '\'  outputfile],DeltaT_HE,strcat(1,'DeltaT_HE'));
DeltaT_Rew_output = xlswrite([directoryname '\'  outputfile],DeltaT_Rew,strcat(1,'DeltaT_Rew'));
LPpermin_output = xlswrite([directoryname '\' outputfile],LPpermin,strcat(1,'LPpermin'));
HEpermin_output = xlswrite([directoryname '\'  outputfile],HEpermin,strcat(1,'HEpermin'));
Rewpermin_output = xlswrite([directoryname '\'  outputfile],Rewpermin,strcat(1,'Rewpermin'));
timeLP_output = timeLP_output;
timeHE_output = timeHE_output;
timeRew_output = timeRew_output;
LPduration_output = LPduration_output;
LPpermin_output = LPpermin_output;
HEpermin_output = HEpermin_output;
Rewpermin_output = Rewpermin_output;