function [  ] = BLSetSLMPower( powerOn )
%==========================================================================
%=   FUNCTION: BNS_SetPower(bPower) modified by BL
%=
%=   PURPOSE: Toggles the SLM power state
%=
%=   INPUTS:  a boolean state - true = power up, false = power down
%=
%=  OUTPUTS:  
%=
%========================================================================== 
    calllib('Interface','SLMPower',powerOn);  


end

