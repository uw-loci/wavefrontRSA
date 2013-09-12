% function [ output_args ] = image2movie( input_args )
%IMAGE2MOVIE Summary of this function goes here
%   Detailed explanation goes here
nIterations = 1;
rectSideLen = 32;
upperbound =1;
lowerbound =512;
leftbound = 1;
rightbound = 512;
phaseStep = 32;
map = colormap('gray');
iframe = 1;
for iIteration = 1:nIterations
    
    for iRow = upperbound:rectSideLen:lowerbound
        
        for iCol = leftbound:rectSideLen:rightbound
            
            for phase = 0:phaseStep:255
                
                imageName = sprintf('/Users/mac/Dropbox/oblique0815_2/R%d%03d%03d.tif',iIteration,iRow,iCol);
                imageData = imread(imageName,'tif'); 
                imageDataGray = repmat(imageData,[1 1 3]);
                M(iframe) = im2frame(imageDataGray);
                iframe = iframe + 1;
            end 
        end 
    end 
end

