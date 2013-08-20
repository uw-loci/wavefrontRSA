function SLMDisp(ImageData)
BNS_OpenSLM();
BNS_SetPower(true);
handles.slm_lut = BNS_ReadLUTFile('C:\BNSMatlabSDK\LUT_Files\slm7846.LUT');

%Load a series of images to the hardware memory - we will sequence
%through these images later when the start/stop button is clicked
% ImageData = zeros(512,512);
% for n = 1:512
%     ImageData(:,n) = 255*(mod(n,4)< 2);
% end

% for pattern = 0:6
%    	BNS_LoadImageFrame(pattern, ImageData, handles);
% end


BNS_LoadImageFrame(1, ImageData, handles);

%Initalize the data on the SLM to be the first pattern
BNS_SendImageFrameToSLM(0);
% for i = 0:6
%     BNS_SendImageFrameToSLM(mod(i,6));
%     pause;
% end
pause; 

BNS_ClosesSLM();
end




