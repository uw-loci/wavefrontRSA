function [  ] = BLOpenSLM(  )
%==========================================================================
%=   FUNCTION:  BNS_OpenSLM() modified by BL 
%=
%=   PURPOSE: Opens all the Boulder Nonlinear Systems SLM driver boards 
%=            in the system.  Assumes the devices are nematic (phase) 
%=            SLMs.  Loads the library "Interface.dll" into the MATLAB
%=            workspace.
%=            
%=   OUTPUTS: 
%=
%==========================================================================
    % load the Interface dll to access the BNS functions
    loadlibrary('C:\BNSMatlabSDK\Interface.dll','C:\BNSMatlabSDK\Interface.h');
    
    % call the constructor passing the LC type, and the toggle rate
    % where LCType is 0 for Amplitude SLMs, and 1 for phase SLMs. The
    % toggle rate should be 3 for Phase SLMs, and is ignored for 
    % Amplitude SLMs (so it can also be 3)
    LCType = int32(1); 
    TrueFrames = int32(3); 
    calllib('Interface','Constructor',LCType, TrueFrames);

    % Set the download mode. Passing true will enable continuous download
    % mode, and passing false will disable continuous download mode. See
    % the manual for more information...
    calllib('Interface','SetDownloadMode', false); 
    
	% Set the run parameters. The first parameter is the FrameRate, 
    % which determines how fast the SLM will switch from one image to 
    % the next.  The second parameter is the LaserDuty, which determines 
    % the percentage of time that the laser is on. 
    % The third parameter is the TrueLaserGain which sets the voltage
	% of the laser output during the true viewing of the image. 
    % The last parameter is the InverseLaserGain which sets the voltage 
    % of the laser output during the inverse viewing of the image. 
    FrameRate = int32(1000);    %number from 1 - 1000 (Hz)
    LaserDuty = int32(50);      %number from 0-100 (Percent laser on)
    TrueLaserGain = int32(255); %number from 0-255 
    InverseLaserGain = int32(0);%number from 0 - 255
    calllib('Interface','SetRunParam', FrameRate, LaserDuty, TrueLaserGain, InverseLaserGain);


end

