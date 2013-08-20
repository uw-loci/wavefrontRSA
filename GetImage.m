%% initialize a video object to dcam
vidobj = videoinput('dcam', 1, 'Y8_800x600');
src = getselectedsource(vidobj);
src.GainMode = 'manual';
src.FrameTimeout = 50000;
src.Gain = 450;
src.AutoExposure = 112;
src.Brightness = 456;
src.Shutter = 181;
preview(vidobj);
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
