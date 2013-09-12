function [ src ] = BLConfigCCD( vid, frameRate, gain, gainMode, shutterSpeed, shutterMode, brightness)
%BLCONFIGCCD configures the input video object, vid, with the supplied frame 
%rate and parameter 
%     INPUT ARGUMENTS
%     vid         video object
%     frameRate   desired frame rate
%     gain        gain
%     shutter     relative shutter speed
%    
%
%     OUTPUT ARGUMENTS
%     vid     video object

src = getselectedsource(vid);
src.FrameTimeout = 5000;

% set trigger properties. 
set(vid, 'FramesPerTrigger', 1);
set(vid, 'TriggerRepeat', Inf);
triggerconfig(vid, 'manual');

% start video object 
start(vid);

switch gainMode
    case 'none'
        
    case 'manual'
         src.GainMode = gainMode;
         src.Gain = gain;
    case 'auto'
         src.GainMode = gainMode;
    otherwise
        disp('unrecognized gain mode. Please add a case in BLConfigCCD');
end 

switch shutterMode
    case 'none'
        
    case 'relative'
         src.ShutterControl = shutterMode;
         src.shutter = shutterSpeed;
    case 'absolute'
         src.ShutterControl = shutterMode;
         src.shutter = shutterSpeed;
    case 'auto'
         src.ShutterControl = shutterMode;
    otherwise 
        disp('unrecognized shutter mode. Please add a case in BLConfigCCD');
end 

if isa(brightness,'double')
    src.Brightness = brightness;
end 


% set frame rate 
src.FrameRate = frameRate;

end
