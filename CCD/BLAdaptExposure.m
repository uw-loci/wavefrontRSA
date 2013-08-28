function [ checkAgain ] = BLAdaptExposure( src, snapshot, tolerance )
%BLADAPTEXPOSURE Summary of this function goes here
%   Detailed explanation goes here

if nargin == 2;
    tolerance = 0.1;
end 

adaptor = tolerance; 
[height, width] = size(snapshot);
nElements = height * width;
buffer = snapshot; 
buffer(buffer ~= 255) = [];
[~, nSaturatedPixels] = size(buffer);



if nSaturatedPixels > tolerance*nElements
    src.Gain = src.Gain*adaptor;
    checkAgain = true; 
end 

end

