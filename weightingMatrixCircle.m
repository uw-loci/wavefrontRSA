function [ wmatrix ] = weightingMatrix2( height,width )

% WeightingMatrix generates a weighting matrix
wmatrix = zeros(height,width);
for m = 1:height
    for n = 1:width
        if (m-height/2)^2 + (n-width/2)^2 < 3000
            wmatrix(m,n) = 1;
        end
    end
end

end




