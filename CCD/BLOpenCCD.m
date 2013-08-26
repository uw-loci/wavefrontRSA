function [ vid ] = BLOpenCCD( deviceID, format, adaptorName )
%BLOPENCCD opens a connection with an image acquisition device specified by
%deviceID, format, and adaptorName. 
%   INPUT ARGUMENTS 
%   deviceID    the number assigned to a device under an adaptorName
%   format      default 'Y8_1024x768'
%   adaptorName default 'dcam'
% 
%   OUTPUT ARGUMENTS 
%   vid     video object opened. 

if nargin < 1
    deviceID = 1;
    format = 'Y8_1024x768';
    adaptorName = 'dcam';
elseif nargin < 2
    format = 'Y8_1024x768';
    adaptorName = 'dcam';
end

vid = videoinput(adaptorName, deviceID, format);


end

