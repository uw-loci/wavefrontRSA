function [finalMask] = Main(rectSideLen,phaseStep,nIterations,folder, useZeros) %% initilize
% tic;
% stop(vidobj);
%% declare extrinsic functions
% coder.extrinsic('strcat');
% coder.extrinsic('loadlibrary');
% coder.extrinsic('libpointer');
% coder.extrinsic('calllib');
% coder.extrinsic('videoinput');
% coder.extrinsic('preview');
% coder.extrinsic('triggerconfig');
% coder.extrinsic('start');
% coder.extrinsic('triggerconfig');
% coder.extrinsic('sprintf');
% coder.extrinsic('fopen');
% coder.extrinsic('fprintf');
% coder.extrinsic('trigger');
% coder.extrinsic('getdata');
% coder.extrinsic('unloadlibrary');
% coder.extrinsic('stop');



pause on;
% profile off;
disp('Initializing variables...');

% change the following parameters
% CCDWidth = 1024;
% CCDHeight = 768;
upperbound = 1;
lowerbound = 512;
leftbound = 1;
rightbound = 512;
% rectSideLen = 16; % the length of unit rectangle on SLM display. All pixels in this rectangle has the same phase
% phaseStep = 16; % the step size of phase modulation.
% nIterations = 1;
% R = zeros(256/phaseStep,1);

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


% previousEmax = 0;
% previousImageData = currentMask;
%% initilize SLM
FrameNum = 0;
disp('initializing SLM...');
% BNS_OpenSLM();
%==========================================================================
%=   FUNCTION:  BNS_OpenSLM()
%=
%=   PURPOSE: Opens all the Boulder Nonlinear Systems SLM driver boards 
%=            in the system.  Assumes the devices are nematic (phase) 
%=            SLMs.  Loads the library "Interface.dll" into the MATLAB
%=            workspace.
%=            
%=   OUTPUTS: 
%=
%==========================================================================
    % load the Interface dll to access the BNS functions
    loadlibrary('C:\BNSMatlabSDK\Interface.dll','C:\BNSMatlabSDK\Interface.h');
    
    % call the constructor passing the LC type, and the toggle rate
    % where LCType is 0 for Amplitude SLMs, and 1 for phase SLMs. The
    % toggle rate should be 6 for Phase SLMs, and is ignored for 
    % Amplitude SLMs (so it can also be 3)
    LCType = int32(1); 
    TrueFrames = int32(3); 
    calllib('Interface','Constructor',LCType, TrueFrames);

    % Set the download mode. Passing true will enable continuous download
    % mode, and passing false will disable continuous download mode. See
    % the manual for more information...
    calllib('Interface','SetDownloadMode', false); 
    
	% Set the run parameters. The first parameter is the FrameRate, 
    % which determines how fast the SLM will switch from one image to 
    % the next.  The second parameter is the LaserDuty, which determines 
    % the percentage of time that the laser is on. 
    % The third parameter is the TrueLaserGain which sets the voltage
	% of the laser output during the true viewing of the image. 
    % The last parameter is the InverseLaserGain which sets the voltage 
    % of the laser output during the inverse viewing of the image. 
    FrameRate = int32(1000);    %number from 1 - 1000 (Hz)
    LaserDuty = int32(50);      %number from 0-100 (Percent laser on)
    TrueLaserGain = int32(255); %number from 0-255 
    InverseLaserGain = int32(0);%number from 0 - 255
    calllib('Interface','SetRunParam', FrameRate, LaserDuty, TrueLaserGain, InverseLaserGain);
    
    
% BNS_SetPower(true);
%==========================================================================
%=   FUNCTION: BNS_SetPower(bPower)
%=
%=   PURPOSE: Toggles the SLM power state
%=
%=   INPUTS:  a boolean state - true = power up, false = power down
%=
%=  OUTPUTS:  
%=
%========================================================================== 
    calllib('Interface','SLMPower',true);  
    
    
% handles.slm_lut = BNS_ReadLUTFile('C:\BNSMatlabSDK\LUT_Files\linear.LUT');


% BNS_LoadImageFrame(0, blank, handles);
% BNS_LoadImageFrame(1, blank, handles);
% BNS_LoadImageFrame(2, blank, handles);

% loop to replace the three lines immediately above 
ImageMatrix = blank;
for ImageFrame = 0:2
    pImage = libpointer('uint8Ptr',ImageMatrix);
    calllib('Interface','WriteFrameBuffer',ImageFrame, pImage, 512);
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

vidRefl = videoinput('dcam', 2, 'Y8_800x600');
srcRefl = getselectedsource(vidRefl);
preview(vidRefl);
set(vidRefl, 'FramesPerTrigger', 1);
set(vidRefl, 'TriggerRepeat', Inf);
triggerconfig(vidRefl, 'manual');
start(vidRefl);
srcRefl.GainMode = 'manual';
srcRefl.FrameTimeout = 5000;
srcRefl.AutoExposure = 90;
srcRefl.Brightness = 0;
srcRefl.Gain = 611;
srcRefl.ShutterMode = 'manual';
srcRefl.ShutterControl = 'relative';
srcRefl.Shutter = 210;
srcRefl.FrameRate = '30';


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
                % BNS_LoadImageFrame(FrameNum, imageData, handles);
                % to replace BNS_LoadImageFrame
                pImage = libpointer('uint8Ptr',currentMask);
                calllib('Interface','WriteFrameBuffer',FrameNum, pImage, 512);
                
                % BNS_SendImageFrameToSLM(FrameNum);
                calllib('Interface','SelectImage',FrameNum);
                pause(0.1);
                
                % getting response from CCD
                % snapshot = getsnapshot(vidobj);
%                 trigger(vidTrans);
%                 snapshotTrans = getdata(vidTrans);
                
                trigger(vidRefl);
                snapshotRefl = getdata(vidRefl);
                
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
                    % sending image to SLM
                    % BNS_SendImageFrameToSLM(2);
                    calllib('Interface','SelectImage',2);
                    pause(0.1);
                    
                    % getting response from CCD
                    % snapshot = getsnapshot(vidobj);
%                     trigger(vidTrans);
%                     snapshotTransCtrl = getdata(vidTrans);
                    
                    trigger(vidRefl);
                    snapshotReflCtrl = getdata(vidRefl);
                    
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

stop(vidRefl);
delete(vidRefl);
close(gcf);
% stop(vidBgd);
% delete(vidBgd);
% close(gcf);
calllib('Interface','SLMPower', false);
calllib('Interface','Deconstructor');
unloadlibrary('Interface');

sendEmail;
% time = toc;
end
