function [ output_args ] = BLLoadImageFrame( ImageFrame, ImageMatrix )
%==========================================================================
%=   FUNCTION:   BNS_LoadImageFrame(ImageFrame,ImageMatrix) modified by BL
%=
%=   PURPOSE:    Loads a image into a memory frame on the SLM driver board.
%=               WARNING - Loading the same memory frame that is currently
%=               being viewed on the SLM can result in corrupted images.  
%=             
%=   INPUTS:     ImageFrame - the memory frame being loaded (integer 0..1024) 
%=               ImageMatrix - A 512x512 matrix or 256x256 of integers, each 
%=                             within range 0..255, corresponding to the voltage
%=                             to be applied to the SLM pixel.
%=               ImageSize - if the image is bigger or smaller than the 
%=                           size of the SLM, then the lower level code
%=                           will scale the image appropriately
%=
%=   OUTPUTS:  
%=
%==========================================================================


    
    % pass an array pointer down to the C++ code
    pImage = libpointer('uint8Ptr',ImageMatrix); 
    calllib('Interface','WriteFrameBuffer',ImageFrame, pImage, 512);

end

