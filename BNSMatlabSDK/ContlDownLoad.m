BNS_OpenSLM();
BNS_SetPower(true);
handles.slm_lut = BNS_ReadLUTFile('C:\BNSMatlabSDK\LUT_Files\linear.LUT');

%Load a series of images to the hardware memory - we will sequence
%through these images later when the start/stop button is clicked
for ImageFrame = 0:6
    %Read in an image - zernike patterns in this case
    ImageData = Get512Zernike(ImageFrame);
    % Load the image to a frame in memory on the PCI card
	BNS_LoadImageFrame(ImageFrame, ImageData, handles); 
end


%Initalize the data on the SLM to be the first pattern
BNS_SendImageFrameToSLM(0);
for i = 0:6
    BNS_SendImageFrameToSLM(mod(i,6));
    pause;
end

BNS_ClosesSLM();




 
   
