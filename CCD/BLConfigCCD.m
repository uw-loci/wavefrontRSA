function [ vid ] = BLConfigCCD( vid, frameRate, gain, shutter)
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

if vargin == 2
    src.GainMode = 'auto';
    src.ShutterMode = 'auto';
    
else 
    src.GainMode = 'manual';
    src.ShutterMode = 'manual';
end 

% set trigger properties. 
set(vid, 'FramesPerTrigger', 1);
set(vid, 'TriggerRepeat', Inf);
triggerconfig(vid, 'manual');

% start video object 
start(vid);

% set gain and brightness 
src.GainMode = 'manual';
src.Brightness = 0;
src.Gain = gain;

% set shutter mode and speed
src.ShutterControl = 'relative';
src.Shutter = shutter;

% set frame rate 
src.FrameRate = frameRate;

end

