function [ imageData ] = Mosaic( pixelsize,phaseStep )
load('primarySpherical.mat');
imageData = uint8(zeros(512,512));
for n = 1:pixelsize:length(cdata)
    for m = 1:pixelsize:length(cdata)
    imageData(n:n+pixelsize-1,m:m+pixelsize-1) = floor(cdata(n+pixelsize/2,m+pixelsize/2)/phaseStep)*phaseStep;
    
    end 
end 
end
