function StatusReport( row,col,phase,efficiency, controlEfficiency, fileID,currentImage, filePath)
%STATUSREPORT accepts image index as the input argument and displays the
%current pixel number, current image index, and saves the current CCD
%capture to C:\Documents and Settings\zeeshan\My
%Documents\MATLAB\SLMCCD\data in tiff format. StatusReport does so every a
%hundred images sent to the SLM.

%% Write E to a text file
fprintf(fileID,'%3d %3d %5d %10f %10f\r\n',row, col, phase, efficiency, controlEfficiency);

%% Image index
% ImageIndexStatus = sprintf('%d images has been sent to the SLM', ImageIndex);
% disp(ImageIndexStatus);



%% Write CCD capture to disk
% option 1: save every image
% imageName = sprintf('r%dc%dph%d.jpg',row,col,phase);
% imageFilePath = strcat(filePath, imageName);
% imwrite(currentImage,imageFilePath);

% option 2: save only one optimized image within each iteration
% if phase == 0
    %% display pixel number
%     PixelNumStatus = sprintf('Current SLM block has the top-left pixel of (%d, %d)',row,col);
%     disp(PixelNumStatus);
    
    if (mod(row,32) == 1) && (mod(col,32) == 1)
        imageName = sprintf('r%dc%dph%d.jpg',row,col,phase);
        imageFilePath = strcat(filePath, imageName);
        imwrite(currentImage,imageFilePath);
        
        %     imageName = sprintf('blankr%dc%d.jpg',row,col);
        %     imageFilePath = strcat(filePath, imageName);
        %     imwrite(blank,imageFilePath);
    end
% end
end

