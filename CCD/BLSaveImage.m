function [  ] = BLSaveImage(filePath, imageNomenclature, iIteration, iRow, iCol, imageData )
%BLSaveImage saves imags
%   Detailed explanation goes here
 imageName = sprintf(imageNomenclature, iIteration, iRow, iCol);
 imageFilePath = strcat(filePath, imageName);
 imwrite(imageData,imageFilePath,'tiff');

end

