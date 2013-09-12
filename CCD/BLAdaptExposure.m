function [ nSaturatedPixels, dbnLoops, conversionFactor ] = BLAdaptExposure( vid, snapshot, score, tolerance, weightFunction )
%BLADAPTEXPOSURE adapts the exposure of the CCD to accommodate for
%saturation issues. 
%   [ nSaturatedPixels, dbnLoops, conversionFactor ] = BLAdaptExposure( vid, snapshot, score, tolerance, weightFunction )
%
%   INPUT ARGUMENTS
%   vid                  video object
%   snapshot             an image
%   score                score of the snapshot
%   tolerance            the percentage of saturated pixel tolerated. Default to 0.1
%   weightFunciton       weightFunction used to compute the score of a snapshot
%
%   OUTPUT ARGUMENTS
%   nSaturatdPixels     number of saturated pixels 
%   dbnLoops            for debug 
%   conversionFactor    conversion factor from old score to new score. 

if nargin == 3;
    tolerance = 0.1;
end 

src = getselectedsource(vid);

adaptor = tolerance; 
[height, width] = size(snapshot);
nElements = height * width;

dbnLoops = 0;

checkAgain = true; 

while checkAgain
    % calculate saturation 
    buffer = snapshot;
    buffer(buffer ~= 255) = [];
    [~, nSaturatedPixels] = size(buffer);


    if nSaturatedPixels > tolerance*nElements
        src.Gain = src.Gain*adaptor;
        checkAgain = true;
        snapshot = BLGetImage(vid);
    else
        newScore = BLFeedback(snapshot,weightFunction);
        checkAgain = false;
        conversionFactor = newScore/score;
    end
    dbnLoops = dbnLoops + 1;
end 
end

