function [ weightFunction ] = spot( height, width, shiftX, shiftY )
% DESCRIPTION
% spot generates a weight fucntion. This weight function gives a weight of 1 to the pixels
% within the spot to be focused on, and a weight of 0 to pixels outside the spot. 
% 
% INPUT ARGUMENTS 
%   height    height of the output image 
%   width     width of the output image
%   shiftX    the x offset from the center of the matrix
%   shiftX    the x offset from the center of the matrix

if nargin < 3
    shiftX = 0;
    shiftY = 0;
end

weightFunction = zeros(height,width);
for m = 1:height
    for n = 1:width
        if (m-height/2-shiftY)^2 + (n-width/2-shiftX)^2 < (height/120)^2 + (width/120)^2
            weightFunction(m,n) = 1;
        end
    end
end
weightFunction = uint8(weightFunction);

end




