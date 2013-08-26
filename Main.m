function [finalMask] = Main(rectSideLen,phaseStep,nIterations,folder, useZeros) %% initilize


%------------------------------------------------------------------------%
%                       User Settings                                    %
%------------------------------------------------------------------------%

% SLM settings 
upperbound = 1;
lowerbound = 512;
leftbound = 1;
rightbound = 512;

% Camera settings 
gain = 384;
shutter = 120; 


%------------------------------------------------------------------------%
%                       Advanced Settings                                %
%------------------------------------------------------------------------%


disp('Initializing variables...');
pause on;
profile off;
filePath = strcat('C:\Documents and Settings\zeeshan\Desktop\',folder);
mkdir(filePath);
bestR = 0;
% currentR = 0;


if useZeros
    bestMask = uint8(zeros(512,512)); % make bestMask all zeros
else
    %     phaseMask = load('C:\Documents and Settings\zeeshan\My Documents\MATLAB\RTratio\phaseMask.mat'); %load imageData, or the next statement
    phaseMask = load('phaseMask.mat'); %load imageData, or the next statement
    bestMask = phaseMask.finalMask;
    %     load('primarySpherical.mat');
    %     imageData = cdata;
end
blank = uint8(zeros(512,512));
% wmatrix = gauss2D(CCDHeight,CCDWidth,5);
% R = zeros(256/phaseStep,1);

% previousEmax = 0;
% previousImageData = currentMask;
%% initilize SLM
FrameNum = 0;
disp('initializing SLM...');

BLopenSLM();
BLsetSLMPower(true);
    
    
% handles.slm_lut = BNS_ReadLUTFile('C:\BNSMatlabSDK\LUT_Files\linear.LUT');


% BNS_LoadImageFrame(0, blank, handles);
% BNS_LoadImageFrame(1, blank, handles);
% BNS_LoadImageFrame(2, blank, handles);

% loop to replace the three lines immediately above 

imageMatrix = blank;

for imageFrame = 0:2
    BLloadImageFrame(imageFrame,imageMatrix)
end 

%% initilize CCD
disp('initializing CCD...');


% vidTrans = videoinput('dcam', 1, 'Y8_1024x768');
% srcTrans = getselectedsource(vidTrans);

% set the properties of video object w/ diffuser
% preview(vidTrans);

% set trigger mode
% set(vidTrans, 'FramesPerTrigger', 1);
% set(vidTrans, 'TriggerRepeat', Inf);
% triggerconfig(vidTrans, 'manual');
% start(vidTrans);

vidRefl = BLOpenCCD(1,'Y8_1024x768');
BLConfigCCD( vidRefl, '30', gain, shutter);


% vidBgd = videoinput('dcam', 1, 'Y8_1024x768');
% vidBgd.ROIposition = [330 100 600 600];
% srcBgd = getselectedsource(vidBgd);
% preview(vidBgd);
% set(vidBgd, 'FramesPerTrigger', 1);
% set(vidBgd, 'TriggerRepeat', Inf);
% triggerconfig(vidBgd, 'manual');
% start(vidBgd);
% srcBgd.Gain = 2048;
% srcBgd.FrameTimeout = 5000;
% srcBgd.Shutter = 1808;





% start(vidobj);
% src.Shutter = 90;
% getsnapshot(vidobj); %take a first snapshot to ensure camera has started
pause;
% stoppreview(vidobj);


%% initialize write-to file
disp('initializing text file...');
logFilePath = strcat(filePath,'RTratio.txt');
fileID = fopen(logFilePath,'w');
% fprintf(fileID,'%3s %3s %3s %5s %10s %10s %10s %10s\r\n','itr', 'row', 'col', 'phase', 'reflectanc', 'transmitta', 'best Ratio', 'control Ra');
fprintf(fileID,'%3s %3s %3s %5s %10s %10s %10s\r\n','itr', 'row', 'col', 'phase', 'currentR', 'bestR', 'controlR');

%% Loop
for iIteration = 1:nIterations
    
    for iRow = upperbound:rectSideLen:lowerbound
        
        for iCol = leftbound:rectSideLen:rightbound
            % display pixel number
            PixelNumStatus = sprintf('Iteration %d, top-left pixel of (%d, %d)',iIteration, iRow, iCol);
            disp(PixelNumStatus);
            for phase = 0:phaseStep:255
                
                currentMask = bestMask;
                currentMask(iRow:iRow+rectSideLen-1,iCol:iCol+rectSideLen-1) = phase;
                
                %% display the phase mask
                
                % sending image to SLM
                BLloadImageFrame(FrameNum,currentMask)
                BLSendImageToSLM(FrameNum);
     
               
                
                % getting response from CCD
                % snapshot = getsnapshot(vidobj);
%                 trigger(vidTrans);
%                 snapshotTrans = getdata(vidTrans);
                
               
                snapshotRefl = BLGetImage(vidRefl);
                
%                 trigger(vidBgd);
%                 snapshotBgd = getdata(vidBgd);
                
                % calculate the focus efficiency
%                 irradTrans = sum(sum(snapshotTrans)); % transmission
                irradRefl = sum(sum(snapshotRefl)); % reflection
%                 irradBgd = sum(sum(snapshotBgd));
                currentR = irradRefl; % /irradBgd; %current reflectance 
%                 currentR = irradRefl/irradTrans; % ratio of reflection irradiance over transmission irradiance. This ratio is to be maximized.
                % R((phase/phaseStep)+1) = currentR;
                
                % display status reports
                % StatusReport(n, m, p, currentE , fileID, snapshot, filePath);
                
                FrameNum = mod(FrameNum + 1, 2);
                
                %% display the blank control
                if (phase == 0) % && (mod(n,64) == 1) && (mod(m,64) == 1)
                    
                    % sending blank image to SLM
                    BLSendImageToSLM(2);
                    
                    % getting response from CCD
                    % snapshot = getsnapshot(vidobj);
%                     trigger(vidTrans);
%                     snapshotTransCtrl = getdata(vidTrans);
                    
                 snapshotReflCtrl = BLGetImage(vidRefl);
                    
%                     trigger(vidBgd);
%                     snapshotBgdCtrl = getdata(vidBgd);
                    % calculate the focus efficiency
%                     irradTransCtrl = sum(sum(snapshotTransCtrl)); % transmission
                    irradReflCtrl = sum(sum(snapshotReflCtrl)); % reflection
%                     irradBgdCtrl = sum(sum(snapshotBgdCtrl));
                    controlR = irradReflCtrl; %/irradBgdCtrl;
%                     controlR = irradReflCtrl/irradTransCtrl; % ratio of reflection irradiance over transmission irradiance. This ratio is to be maximized.
                    
                    % E((p/phaseStep)+1) = currentE;
                    
                    % display status reports
                    % StatusReport(iIteration, iRow, iCol, phase, currentR , controlR, fileID);
                    fprintf(fileID,'%3d %3d %3d %5d %10.0f %10.0f %10.0f\r\n',iIteration, iRow, iCol, phase, currentR, bestR, controlR);
                                                        
                    % save images 
%                     imageName = sprintf('T%d%03d%03d.tif',iIteration,iRow,iCol);
%                     imageFilePath = strcat(filePath, imageName);
%                     imwrite(snapshotTrans,imageFilePath,'tiff');
                    
                    imageName = sprintf('R%d%03d%03d.tif',iIteration,iRow,iCol);
                    imageFilePath = strcat(filePath, imageName);
                    imwrite(snapshotRefl,imageFilePath,'tiff');
                    
%                     imageName = sprintf('CT%d%03d%03d.tif',iIteration,iRow,iCol);
%                     imageFilePath = strcat(filePath, imageName);
%                     imwrite(snapshotTransCtrl,imageFilePath,'tiff');
                    
                    imageName = sprintf('CR%d%03d%03d.tif',iIteration,iRow,iCol);
                    imageFilePath = strcat(filePath, imageName);
                    imwrite(snapshotReflCtrl,imageFilePath,'tiff');
                end
                
                
                if currentR > bestR
                    bestMask = currentMask;
                    bestR = currentR;
                end 
            end
            % R_index = (R == max(R));
            % if previousEmax <= max(R)
            %     idxBuffer = find(R_index,1,'first')-1;
            %     idx = idxBuffer(1,1);
            %     currentMask(iRow:iRow+rectSideLen-1,iCol:iCol+rectSideLen-1) = phaseStep*idx;
            %              imageData(iRow:iRow+rectSideLen-1,iCol:iCol+rectSideLen-1) = ;
            %
            %     % Subtracting 1 because the LUT has range the index of E starts at 1
            % else
            %     currentMask = previousImageData;
            %     % If this iteration has less maximal efficiency then use the
            %     % imageData from the last iteration.
            % end
            %
            %
            % previousEmax = max(R);
            % previousImageData = currentMask;
            % EArray(n,m,:) = E;
        end
    end
end

%% close program and save data
phaseMaskPath = strcat(filePath,'phaseMask.mat');
finalMask = bestMask;
save(phaseMaskPath,'finalMask');
fclose(fileID);

BLCloseCCD(vid);
% stop(vidBgd);
% delete(vidBgd);
% close(gcf);
BLCloseSLM;

sendEmail;
% time = toc;
end
