%% initilize
% tic;
% stop(vidobj);
pause on;
profile off;
disp('Initializing variables...');

% change the following parameters
CCDWidth = 1024;
CCDHeight = 768;
rectSideLen = 16; % the length of unit rectangle on SLM display. All pixels in this rectangle has the same phase
phaseStep = 16; % the step size of phase modulation.
E = zeros(256/phaseStep,1);
filePath = 'C:\Documents and Settings\zeeshan\Desktop\SLMCCDData072413\';
load('phaseMask.mat'); %load imageData, or the next statement
% imageData = uint8(zeros(512,512)); % make imageData all zeros
% load('primarySpherical.mat');
% imageData = cdata;
blank = uint8(zeros(512,512));
wmatrix = gauss2D(CCDHeight,CCDWidth,5);


previousEmax = 0;
previousImageData = imageData;
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
fprintf(fileID,'%3s %3s %3s %5s %10s %10s\r\n','itr', 'row','col','phase','eff', 'ctr');

%% Loop
for nIteration = 1:3
    
    for n = 1:rectSideLen:512
        
        for m = 1:rectSideLen:512
            % display pixel number
            PixelNumStatus = sprintf('Iteration %d, top-left pixel of (%d, %d)',nIteration, n, m);
            disp(PixelNumStatus);
            for p = 0:phaseStep:255
                imageData(n:n+rectSideLen-1,m:m+rectSideLen-1) = p;
                
                %% display the phase mask
                
                % sending image to SLM
                BNS_LoadImageFrame(FrameNum, imageData, handles);
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
                if (p == 0) % && (mod(n,64) == 1) && (mod(m,64) == 1)
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
                    StatusReport(nIteration, n, m, p, currentE , controlE, fileID, snapshot, blank, filePath);
                end
            end
            E_index = (E == max(E));
            if previousEmax <= max(E)
                imageData(n:n+rectSideLen-1,m:m+rectSideLen-1) = phaseStep*(find(E_index)-1);
                % Subtracting 1 because the LUT has range the index of E starts at 1
            else
                imageData = previousImageData;
                % If this iteration has less maximal efficiency then use the
                % imageData from the last iteration.
            end
            
            
            previousEmax = max(E);
            previousImageData = imageData;
            % EArray(n,m,:) = E;
        end
    end
end

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
