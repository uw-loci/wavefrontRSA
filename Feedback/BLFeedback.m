function [ score ] = BLFeedback( snapshot, weightFunction )
%feedback calculates the score of a snapshot.
%
% INPUT ARGUMENTS
%   snapshot        an image
%   weightFunction  see weightFunctions/ for more info.
%
% OUTPUT ARGUMENTS
%   score           score of the snapshot


if weightFunction 
    score = sum(sum(snapshot));
else 
    score = sum(sum(double(snapshot).*weightFunction))/sum(sum(snapshot));
end

end

