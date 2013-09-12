function [ power ] = BLGetPower( s )
%BLSENDTOPOWERMETER send a command to a serial connection instance
%   function [ response ] = BLSendToPowerMeter( s, command )
%   INPUT ARGUMENTS
%   s           a instance of serial connection
%  
%
%   OUTPUT ARGUMENTS
%   power    response received from s

fprintf(s,'Pwr?' );
powerBuffer = fscanf(s);
power = str2double(powerBuffer(5:end));



end

