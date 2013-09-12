function BNS_CloseSLM()
%==========================================================================
%=   FUNCTION:  BNS_CloseSLM()
%=
%=   PURPOSE:   Closes the Boulder Nonlinear Systems SLM driver boards
%=              and unloads Interface.dll from the MATLAB Workspace
%==========================================================================
   calllib('Interface','SLMPower', false);
   calllib('Interface','Deconstructor');
   unloadlibrary('Interface');
