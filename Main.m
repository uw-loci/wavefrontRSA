%% initilize
tic;
pause on;
profile off;
% profile clear;
disp('Initializing variables...');
CCDWidth = 800;
CCDHeight = 600;
% pixelnum = [1 1];
% ImageIndex = 1;
% EArray = zeros(64,64,16);
% phase = zeros(512,512);
rectSideLen = 16; % the length of unit rectangle on SLM display. All pixels in this rectangle has the same phase
phaseStep = 8; % the step size of phase modulation.
E = zeros(256/phaseStep,1);
filePath = 'C:\Documents and Settings\zeeshan\Desktop\SLMCCDData070113\';
wmatrix = gauss2D(CCDHeight,CCDWidth,15);
% ImageData = uint8(zeros(512,512));
blank = uint8(zeros(512,512));
ImageData = Mosaic(rectSideLen,phaseStep);
%load('C:\Documents and Settings\zeeshan\My Documents\MATLAB\SLMCCD.v3\weightingMatrix.mat');
previousEmax = 0;
previousImageData = ImageData; 
%% initilize SLM
FrameNum = 0;
disp('initializing SLM...');
BNS_OpenSLM();
BNS_SetPower(true);
handles.slm_lut = BNS_ReadLUTFile('C:\BNSMatlabSDK\LUT_Files\linear.LUT');
BNS_LoadImageFrame(0, blank, handles);
BNS_LoadImageFrame(1, blank, handles);
BNS_LoadImageFrame(2, blank, handles);
%% initilize CCD
disp('initializing CCD...');
vidobj = videoinput('dcam', 1, 'Y8_800x600');

% set the properties of video object
src = getselectedsource(vidobj);
src.GainMode = 'manual';
src.FrameTimeout = 500000;
src.Gain = 400;
src.AutoExposure = 106;
src.Brightness = 339;
% src.Shutter = 3;
src.ShutterControl = 'absolute';
src.ShutterAbsolute = 0.002;
set(vidobj, 'FramesPerTrigger', 1);
set(vidobj, 'TriggerRepeat', Inf);
triggerconfig(vidobj, 'manual');
start(vidobj);
% preview(vidobj);
% getsnapshot(vidobj); %take a first snapshot to ensure camera has started
% pause;
% stoppreview(vidobj);


%% initialize write-to file
disp('initializing text file...');
logFilePath = strcat(filePath,'FocusEfficiency.txt');
fileID = fopen(logFilePath,'w');
fprintf(fileID,'%3s %3s %5s %10s %10s\r\n','row','col','phase','eff', 'ctr');

%% Loop
for n = 1:rectSideLen:512
    for m = 1:rectSideLen:512
        
        for p = 0:phaseStep:255
            ImageData(n:n+rectSideLen-1,m:m+rectSideLen-1) = p;
            
            %% display the phase mask
                       
            % sending image to SLM
            BNS_LoadImageFrame(FrameNum, ImageData, handles);
            BNS_SendImageFrameToSLM(FrameNum);
            pause(0.1);
            
            % getting response from CCD
            % snapshot = getsnapshot(vidobj);
            trigger(vidobj);
            snapshot = getdata(vidobj);
            
            % calculate the focus efficiency
            currentE = FocusEff(snapshot,wmatrix);
            E((p/phaseStep)+1) = currentE;
            
            % display status reports 
            % StatusReport(n, m, p, currentE , fileID, snapshot, filePath);
            
            FrameNum = mod(FrameNum + 1, 2);
            
            %% display the blank control 
                        
            % sending image to SLM
            BNS_SendImageFrameToSLM(2);
            pause(0.1);
            % getting response from CCD
            % snapshot = getsnapshot(vidobj);
            trigger(vidobj);
            blank = getdata(vidobj);
            
            % calculate the focus efficiency
            controlE = FocusEff(blank,wmatrix);
            % E((p/phaseStep)+1) = currentE;
            
            % display status reports 
            StatusReport(n, m, p, currentE , controlE, fileID, snapshot, blank, filePath);
            
        end
        E_index = (E == max(E));
        if previousEmax <= max(E)
            ImageData(n:n+rectSideLen-1,m:m+rectSideLen-1) = phaseStep*(find(E_index)-1);
            % Subtracting 1 because the LUT has range the index of E starts at 1
        else
            ImageData = previousImageData;
            % If this iteration has less maximal efficiency then use the
            % ImageData from the last iteration.
        end
        
        
        previousEmax = max(E);
        previousImageData = ImageData;
        % EArray(n,m,:) = E;
    end
end
phaseMaskPath = strcat(filePath,'phaseMask.mat');
save(phaseMaskPath,'ImageData');
% stoppreview(vidobj);
stop(vidobj);
BNS_ClosesSLM();
time = toc;