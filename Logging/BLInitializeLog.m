function [  ] = BLInitializeLog( directory, fileName, nInputDevices )
%BLINITIALIZELOG initialize a log file in txt format with fields
%iteration(itr), row, col, phase, best score, score and control score.
%Score and control score are numbered up to three devices. 
%   INPUT ARGUMENTS
%   directory   folder the log will reside in
%   fileName    file name of the log file 
%   nInputDevices   number of input devices(up to 3). If more than 3, the user
%   should make changes to this program 
%   
%   OUTPUT ARGUMENTS 
%   N/A

disp('initializing log...');
filePath = strcat(directory,fileName);
fileID = fopen(filePath,'w');

switch nInputDevices
    case 1 
        fprintf(fileID,'%3s %3s %3s %5s %10s %10s %10s\r\n','itr', 'row',... 
        'col', 'phase', 'best score', 'score', 'ctrl score');
    case 2
        fprintf(fileID,'%3s %3s %3s %5s %10s %10s %10s\r\n','itr', 'row',...
         'col', 'phase', 'bestscore','score1', 'ctrlscore1', 'score2', 'ctrlscore2');
    case 3
        fprintf(fileID,'%3s %3s %3s %5s %10s %10s %10s\r\n','itr', 'row',...
         'col', 'phase', 'bestscore', 'score1', 'ctrlscore1', 'score2',...
         'ctrlscore2', 'score3', 'ctrlscore3');
    otherwise 
        disp('Too many input devices. Please change BLInitializeLog')
end
end 
