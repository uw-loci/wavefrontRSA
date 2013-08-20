function [wmatrix] = distanceFromFoci(ccdHeight, ccdWidth)
% DESCRIPTION
% distanceFromFoci generates a weighting matrix. This weight of the center
% pixels has the highest weight, which decreases linearly as the distance
% from the center increases. 
% 
% INPUT ARGUMENTS 
%   height    height of the output image 
%   width     width of the output image
wmatrix = zeros(ccdHeight,ccdWidth);
for m = 1:ccdHeight
    for n = 1:ccdWidth
        wmatrix(m,n) = sqrt((m-ccdHeight/2)^2+(n-ccdWidth/2)^2);
    end
end
wmatrix = (max(max(wmatrix))-wmatrix)/max(max(wmatrix));
end



