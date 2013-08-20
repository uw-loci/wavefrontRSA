function [wmatrix] = weightingMatrixDistance(ccdHeight, ccdWidth)
% WeightingMatrix generates a weighting matrix
wmatrix = zeros(ccdHeight,ccdWidth);
for m = 1:ccdHeight
    for n = 1:ccdWidth
        wmatrix(m,n) = sqrt((m-ccdHeight/2)^2+(n-ccdWidth/2)^2);
    end
end
wmatrix = (max(max(wmatrix))-wmatrix)/max(max(wmatrix));
end



