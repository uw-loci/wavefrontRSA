function [ height, width ] = extractDimensions( string )
%EXTRACTDIMENSION Summary of this function goes here
%   Detailed explanation goes here
underscore = strfind(lower(string),'_');
x = strfind(lower(string),'x');
width = str2double(string(underscore+1:x-1));
height = str2double(string(x+1:end));

end

