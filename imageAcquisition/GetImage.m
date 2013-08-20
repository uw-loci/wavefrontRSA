%% initialize a video object to dcam

vidobj1 = videoinput('dcam', 1, 'Y8_1024x768');
vidobj2 = videoinput('dcam', 2, 'Y8_800x600');


%% set the properties of video object
% src = getselectedsource(vidobj{1});
% src.GainMode = 'manual';
% src.FrameTimeout = 5000;
% src.Gain = 384;
% src.AutoExposure = 150;
% src.Brightness = 0;
% src.ShutterMode = 'manual';
% src.ShutterControl = 'relative';
% src.Shutter = 90;
% src.FrameRate = '30';
% vid.ROIPosition = [200 0 768 768];


preview(vidobj1);
preview(vidobj2);
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
