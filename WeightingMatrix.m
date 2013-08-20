function [wmatrix] = WeightingMatrix
% WeightingMatrix generates a weighting matrix
wmatrix = zeros(600,800);
for m = 1:600
    for n = 1:800
        wmatrix(m,n) = sqrt((m-300)^2+(n-400)^2);
    end
end
wmatrix = (max(max(wmatrix))-wmatrix)/max(max(wmatrix));
end
