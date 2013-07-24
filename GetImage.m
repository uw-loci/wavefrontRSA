%% initialize a video object to dcam
vidobj = videoinput('dcam', 1, 'Y8_640x480');


%% set the properties of video object
src = getselectedsource(vidobj);
src.GainMode = 'manual';
src.FrameTimeout = 5000;
src.Gain = 384;
src.AutoExposure = 150;
src.Brightness = 0;
src.ShutterMode = 'manual';
src.ShutterControl = 'relative';
src.Shutter = 90;
src.FrameRate = '30';



preview(vidobj);
% pause;
% testshot = getsnapshot(vidobj); %take a first snapshot to ensure camera has started
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
