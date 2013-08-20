function [ ImageData ] = ModPhase
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% preallocate ImageData
ImageData = zeros(512,512);
for n = 1:8:512
    for m = 1:8:512
        ImageData = zeros(512,512);
        for p = 0:16:255
            ImageData(n:n+8,m:m+8) = p;
            %disp(ImageData);
        end
    end
end

end

