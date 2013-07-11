%% initialize a video object to dcam
vidobj = videoinput('dcam', 1, 'Y8_800x600');
vidobj = videoinput('dcam', 1, 'Y8_800x600');

% set the properties of video object
src = getselectedsource(vidobj);
src.GainMode = 'manual';
src.FrameTimeout = 50000;
src.Gain = 400;
src.AutoExposure = 106;
src.Brightness = 339;
% src.Shutter = 3;
src.ShutterControl = 'absolute';
src.ShutterAbsolute = 0.01;
preview(vidobj);
testshot = getsnapshot(vidobj); %take a first snapshot to ensure camera has started
% pause;
% stoppreview(vidobj);
%%
% tic
% currentImage = getsnapshot(vidobj);
% imagesc(currentImage);
% imwrite(currentImage, 'C:\Documents and Settings\zeeshan\Desktop\test3.jpg','bitdepth',16 );
% toc
%% 

% beforealgorithm1 = getsnapshot(vidobj);
% 
% % Display the frame in a figure window.
% figure(1);
% imagesc(beforealgorithm1);
% colormap(gray);
