function [  ] = BLLog(fileID, iIteration, iRow, iCol, phase, bestScore, score1, controlScore1, score2, controlScore2, score3, controlScore3)
%BLLOG writes date to a log file.
%   INPUT ARGUMENTS 
%   They are all data!

switch nargin
    case 12
        fprintf(fileID,'%3d %3d %3d %5d %10e %10e %10e %10e %10e %10e %10e\r\n',iIteration, iRow, ...
            iCol, phase, bestScore, score1, controlScore1, score2, controlScore2, score3, controlScore3);
    case 10
        fprintf(fileID,'%3d %3d %3d %5d %10.0e %10.0e %10.0e %10.0e %10.0e\r\n',iIteration, iRow, ...
            iCol, phase, bestScore, score1, controlScore1, score2, controlScore2);
    case 8
        fprintf(fileID,'%3d %3d %3d %5d %10.0e %10.0e %10.0e\r\n',iIteration, iRow, ...
            iCol, phase, bestScore, score1, controlScore1);   
    otherwise 
        disp('Incorrect number of inputs');
end
end 

