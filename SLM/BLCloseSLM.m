function BLCloseSLM()
%==========================================================================
%=   FUNCTION:  BNS_CloseSLM() modified by BL
%=
%=   PURPOSE:   Closes the Boulder Nonlinear Systems SLM driver boards
%=              and unloads Interface.dll from the MATLAB Workspace
%==========================================================================
   calllib('Interface','SLMPower', false);
   calllib('Interface','Deconstructor');
   unloadlibrary('Interface');



end

