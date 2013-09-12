function LUT = BNS_ReadLUTFile(LUTFileName)
%==========================================================================
%=   FUNCTION: LUT = BNS_ReadLUTFile(LUTFileName)
%=
%=   PURPOSE: Calls a C++ sub-function to read and return the LUT
%=
%=   INPUTS:  The LUT File Name
%=
%=  OUTPUTS:  LUT - a 256 element array of integers in the range of 0..255.
%=
%==========================================================================
    LUT = ones(256,1);
    pLUTData = libpointer('uint8Ptr', LUT);
    LUT = calllib('Interface','ReadLUTFile',pLUTData, LUTFileName);        
   