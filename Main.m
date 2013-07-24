%% initilize
% tic;
% stop(vidobj);
pause on;
profile off;
disp('Initializing variables...');

% change the following parameters
CCDWidth = 1024;
CCDHeight = 768;
% rectSideLen = 16; % the length of unit rectangle on SLM display. All pixels in this rectangle has the same phase
% phaseStep = 16; % the step size of phase modulation.
% E = zeros(256/phaseStep,1);
filePath = 'C:\Documents and Settings\zeeshan\Desktop\SLMCCDData072413\';
% load('phaseMask.mat'); %load imageData, or the next statement
imageData = uint8(zeros(512,512)); % make imageData all zeros
% load('primarySpherical.mat');
% imageData = cdata;
blank = uint8(zeros(512,512));
nElements = numel(blank);
wmatrix = gauss2D(CCDHeight,CCDWidth,5);
currentE = 0;
controlE = 0;
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
vidobj = videoinput('dcam', 1, 'Y8_1024x768');
src = getselectedsource(vidobj);


% set the properties of video object w/ diffuser
preview(vidobj);

% set trigger mode
set(vidobj, 'FramesPerTrigger', 1);
set(vidobj, 'TriggerRepeat', Inf);
triggerconfig(vidobj, 'manual');
start(vidobj);
% pause;


% src.GainMode = 'manual';
% src.FrameTimeout = 5000;
% src.Gain = 384;
% src.AutoExposure = 90;
% src.Brightness = 0;
% src.ShutterMode = 'manual';
% src.ShutterControl = 'absolute';
% src.ShutterAbsolute = 0.02;
% src.FrameRate = '30';





% start(vidobj);
% src.Shutter = 90;
% getsnapshot(vidobj); %take a first snapshot to ensure camera has started
pause;
% stoppreview(vidobj);


%% initialize write-to file
disp('initializing text file...');
logFilePath = strcat(filePath,'FocusEfficiency.txt');
fileID = fopen(logFilePath,'w');
fprintf(fileID,'%3s %10s %10s\r\n','itr', 'eff', 'ctr');

%% Loop
iteration = 0;
while currentE < 3*controlE
    iteration = iteration+1;

    % display status
    status = sprintf('Iteration: %d, e: %d ',iteration, currentE);
    disp(status);
    
    % create trialImageData
    phaseIncrement = blank;
    phaseIncrement(randperm(nElements,nElements/2)) = 32;
    trialImageData = imageData + phaseIncrement;
    
    %% display the phase mask
    
    % sending image to SLM
    BNS_LoadImageFrame(FrameNum, trialImageData, handles);
    BNS_SendImageFrameToSLM(FrameNum);
    pause(0.1);
    
    % getting response from CCD
    % snapshot = getsnapshot(vidobj);
    trigger(vidobj);
    snapshot = getdata(vidobj);
    
    % calculate the focus efficiency
    currentE = FocusEff(snapshot,wmatrix);
    
    
    % display status reports
    % StatusReport(n, m, p, currentE , fileID, snapshot, filePath);
    
    FrameNum = mod(FrameNum + 1, 2);
    
    %% display the blank control
    if mod(iteration,50) == 1  % && (mod(n,64) == 1) && (mod(m,64) == 1)
        % sending image to SLM
        BNS_SendImageFrameToSLM(2);
        pause(0.1);
        % getting response from CCD
        % snapshot = getsnapshot(vidobj);
        trigger(vidobj);
        snapshotCtrl = getdata(vidobj);
        
        % calculate the focus efficiency
        controlE = FocusEff(snapshotCtrl,wmatrix);
        % E((p/phaseStep)+1) = currentE;
        
        % display status reports
        StatusReport(iteration, currentE, controlE, fileID, snapshot, snapshotCtrl, filePath);
    end

    if previousE < currentE

        imageData = trialImageData;
        
    end
end % while
 

%% close the program and save data
phaseMaskPath = strcat(filePath,'phaseMask.mat');
save(phaseMaskPath,'imageData');
% stoppreview(vidobj);
stop(vidobj);

try 
BNS_ClosesSLM();
catch
end 
time = toc;
sendEmail
