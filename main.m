function [finalMask] = main(tileSideLength, phaseStepSize, nIterations, folder, initialPhaseMask, weightFunctionName) %% initilize
% main optmizes phase mask by performing actions in the following order.
% 
% INPUT ARGUMENTS
%   tileSideLength      the side length of a unit tile on SLM. Default = 32
%   phaseStepSize       the size of a phase step in units of gray levels.
%                       Default = 16.
%   nIterations         number of iterations. Default = 1.
%   folder              folder to save the log and images. Default to date
%                       and time. 
%   initialPhaseMask    the very first phase mask to be displayed on the
%                       SLM. Initial phase mask is default to 'zeros', which will make the initial phase mask all
%                       zeros
%   weightFunctions     weight function to determine an image's score.
%                       Options 'gaussian'
%                               'spot'
%                               'distance'
%                               'none' (Default)
%
% OUTPUT ARGUMENTS
%   finalMask           the optimized mask
%
% WARNING
% this program has only been tested on SONY XCD X710/X700 Cameras, X-CITE
% XR2100 Power Meter,  
% and Boulder Nonlinear SLMs. The user may need to change the code to accommedate
% for other devices.
%
% AUTHOR: Bosh Liu <bliu@iwu.edu>
% Version v0.1
% Date: 08/28/2013

%------------------------------------------------------------------------%
%                       User Settings                                    %
%------------------------------------------------------------------------%

% SLM settings
upperbound = 1;
lowerbound = 512;
leftbound = 1;
rightbound = 512;

% Camera 1 settings (SONY XCD X700)
gainMode1 = 'none';
gain1 = 2048;
shutterControl1 = 'none';
shutter1 = 1808;
brightness1 = 'none';
frameRate1 = '15';
format1 = 'Y8_1024x768';
useCamera1 = false;

% Camera 2 settings (SONY XCD X710)
gainMode2 = 'manual';
gain2 = 495;
shutterControl2 = 'relative';
shutter2 = 76;
brightness2 = 0;
frameRate2 = '30';
format2 = 'Y8_1024x768';
useCamera2 = true;

% Power meter settings
usePowerMeter = true;
port = 'COM3';


% Logging
parentDirectory = 'C:\Documents and Settings\zeeshan\Desktop\'; % parent directory to the folder where data will be located
logFileName = 'log.txt';

%------------------------------------------------------------------------%
%                       Advanced Settings                                %
%------------------------------------------------------------------------%
blank = uint8(zeros(512));

% initilize scores and control scores
score1 = 0;
controlScore1 = 0;

score2 = 0;
controlScore2 = 0;


score3 = 0;
controlScore3 = 0;

switch nargin
    case 5
        weightFunctionName = 'none';
    case 4
        weightFunctionName = 'none';
        initialPhaseMask = blank;
    case 3
        weightFunctionName = 'none';
        initialPhaseMask = blank;
        format shortg
        dateTime = clock;
        folder = strcat(num2str(dateTime(1)),num2str(dateTime(2)),...
            num2str(dateTime(3)),num2str(dateTime(4)),num2str(dateTime(5)),'\');
    case 2
        weightFunctionName = 'none';
        initialPhaseMask = blank;
        format shortg
        dateTime = clock;
        folder = strcat(num2str(dateTime(1)),num2str(dateTime(2)),...
            num2str(dateTime(3)),num2str(dateTime(4)),num2str(dateTime(5)),'\');
        nIterations = 1;
    case 1
        weightFunctionName = 'none';
        format shortg
        dateTime = clock;
        initialPhaseMask = blank;
        folder = strcat(num2str(dateTime(1)),num2str(dateTime(2)),...
            num2str(dateTime(3)),num2str(dateTime(4)),num2str(dateTime(5)),'\');
        nIterations = 1;
        phaseStepSize = 16;
    case 0
        weightFunctionName = 'none';
        format shortg
        dateTime = clock;
        initialPhaseMask = blank;
        folder = strcat(num2str(dateTime(1)),num2str(dateTime(2)),...
            num2str(dateTime(3)),num2str(dateTime(4)),num2str(dateTime(5)),'\');
        nIterations = 1;
        phaseStepSize = 16;
        tileSideLength = 32;
end

disp('Initializing variables...');
pause on;
profile off;
directory = strcat(parentDirectory,folder);
mkdir(directory);
bestScore = 0;


if isa(initialPhaseMask,'char')
    bestMask = blank; 
else
    bestMask = initialPhaseMask; % make bestMask all zeros
end


% extrac height and width from format
[height1, width1] = extractDimensions(format1);
[height2, width2] = extractDimensions(format2);

% choose weight function
switch weightFunctionName
    case 'gaussian'
        
        weightFunction1 = gauss2D(height1, width1, 60);
        weightFunction2 = gauss2D(height2, width2, 60);
    case 'spot'
        xOffset1 = 0;
        yOffset1 = 0;
        xOffset2 = 0;
        yOffset2 = 0;
        weightFunction1 = spot(height1, width1, xOffset1, yOffset1);
        weightFunction2 = spot(height2, width2, xOffset2, yOffset2);
    case 'distance'
        weightFunction1 = distanceFromFoci(height1, width1);
        weightFunction2 = distanceFromFoci(height2, width2);
    case 'none'
        weightFunction1 = 1;
        weightFunction2 = 1;
end



%% initilize SLM
frameNum = 0;
disp('initializing SLM...');

BLOpenSLM();
BLSetSLMPower(true);

for imageFrame = 0:2
    BLLoadImageFrame(imageFrame,blank)
end

%% initilize acquisition devices
disp('initializing CCD...');


if useCamera1
    vid1 = BLOpenCCD(1, format1,'dcam');
    src1 = BLConfigCCD(vid1, frameRate1, gain1, gainMode1, shutter1, shutterControl1, brightness1);
    preview(vid1);
end

if useCamera2
    vid2 = BLOpenCCD(2, format2,'dcam');
    src2 = BLConfigCCD(vid2, frameRate2, gain2, gainMode2, shutter2, shutterControl2, brightness2);
    preview(vid2);
end

if usePowerMeter
    powerMeter = BLOpenPowerMeter(port);
%     powerMeterMode = BLGetPower(powerMeter);
end

pause;
%% initialize log file
disp('initializing text file...');
nInputDevices = 3;
fileID = BLInitializeLog(directory,logFileName,nInputDevices);

%% Loop
for iIteration = 1:nIterations
    
    for iRow = upperbound:tileSideLength:lowerbound
        
        for iCol = leftbound:tileSideLength:rightbound
            % display pixel number
            pixelNumStatus = sprintf('Iteration %d, top-left pixel of (%d, %d)',iIteration, iRow, iCol);
            disp(pixelNumStatus);
            for phase = 0:phaseStepSize:255
                
                currentMask = bestMask;
                currentMask(iRow:iRow+tileSideLength-1,iCol:iCol+tileSideLength-1) = phase;
                
                %% display the phase mask
                
                % sending image to SLM
                BLLoadImageFrame(frameNum,currentMask)
                BLSendImageToSLM(frameNum);
                
              
                
                if useCamera1
                    snapshot1 = BLGetImage(vid1);
                    score1 = BLFeedback(snapshot1,weightFunction1);
                    conversionFactor1 = BLAdaptExposure(vid1,snapshot1,score1,0.1,1);
                    score1= score1*conversionFactor1;
                end 
                
                if useCamera2             
                    snapshot2 = BLGetImage(vid2);
                    score2 = BLFeedback(snapshot2,weightFunction2);
                    conversionFactor2 = BLAdaptExposure(vid2,snapshot2,score2,0.1,1);
                    score2= score2*conversionFactor2;
                end 
               
                if usePowerMeter 
                    power = BLGetPower(powerMeter); 
                end 
                frameNum = mod(frameNum + 1, 2);
                
                %% display the blank control
                if (phase == 0) 
                    
                    % sending blank image to SLM
                    BLSendImageToSLM(2);
                    
                    if useCamera1
                        controlSnapshot1 = BLGetImage(vid1);
                        controlScore1 = BLFeedback(controlSnapshot1,weightFunction1);
                    end
                    
                    if useCamera2
                        controlSnapshot2 = BLGetImage(vid2);
                        controlScore2 = BLFeedback(controlSnapshot2,weightFunction2);                        
                    end
                    
                    if usePowerMeter
                        controlPower = BLGetPower(powerMeter);
                    end
                  
                    BLLog(fileID, iIteration, iRow, iCol, phase, bestScore, score1, controlScore1, score2, controlScore2, power, controlPower);
                    
                    if useCamera1
                        BLSaveImage(directory,'Cam1%d%03d%03d.tif', iIteration, iRow, iCol, snapshot1);
                        BLSaveImage(directory,'Cam1Control%d%03d%03d.tif', iIteration, iRow, iCol, controlSnapshot1);
                    end
                    
                    if useCamera2
                        BLSaveImage(directory,'Cam2%d%03d%03d.tif', iIteration, iRow, iCol, snapshot2);
                        BLSaveImage(directory,'Cam2Control%d%03d%03d.tif', iIteration, iRow, iCol, controlSnapshot2);
                    end
                    
                end % phase == 0
                
                
                if score2 > bestScore
                    bestMask = currentMask;
                    bestScore = score2;
                end
            end % phase step
        end % iCol 
    end % iRow
end % iIteration

%% close program and save data
phaseMaskPath = strcat(directory,'phaseMask.mat');
finalMask = bestMask;
save(phaseMaskPath,'finalMask');
fclose(fileID);

if useCamera1
    BLCloseCCD(vid1);
end 
if useCamera2
    BLCloseCCD(vid2);
end 

if usePowerMeter
    BLClosePowerMeter(powerMeter);
end 
BLCloseSLM;

sendEmail;

end

