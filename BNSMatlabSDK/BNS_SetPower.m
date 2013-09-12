function BNS_SetPower(bPower)
%==========================================================================
%=   FUNCTION: BNS_SetPower(bPower)
%=
%=   PURPOSE: Toggles the SLM power state
%=
%=   INPUTS:  a boolean state - true = power up, false = power down
%=
%=  OUTPUTS:  
%=
%========================================================================== 
    calllib('Interface','SLMPower',bPower);         
