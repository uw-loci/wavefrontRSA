function BNS_SendImageFrameToSLM(ImageFrame)
%==========================================================================
%=   FUNCTION:  BNS_SendImageFrameToSLM(ImageFrame)
%=
%=   PURPOSE:   Sends a new image (stored in a memory frame) out the SLM
%=              device for viewing.                    
%=
%=   INPUTS:    ImageFrame - the memory frame being loaded (integer 0..1022) 
%==========================================================================
    calllib('Interface','SelectImage',ImageFrame);
