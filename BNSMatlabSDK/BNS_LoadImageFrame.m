function BNS_LoadImageFrame(ImageFrame, ImageMatrix, handles)
%==========================================================================
%=   FUNCTION:   BNS_LoadImageFrame(ImageFrame,ImageMatrix)
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

    %Add our phase optimization if selected, modulo 256
%     if(handles.apply_optimization)
%         ImageMatrix = mod(ImageMatrix + handles.optimization_data, 256);
%     end;
%     
    %increment the data up to 1 - 256 because Matlab isn't zero based
%     ImageMatrix = ImageMatrix+1;
    
    % process the image through the LUT to remap the data such that
    % a linear phase response results
%     for row=1:512
%         for col=1:512
%              ImageMatrix(row,col) = handles.slm_lut(ImageMatrix(row,col));
%         end
%     end
%     ImageMatrix = uint8(ImageMatrix);
    
    % pass an array pointer down to the C++ code
    pImage = libpointer('uint8Ptr',ImageMatrix); 
    calllib('Interface','WriteFrameBuffer',ImageFrame, pImage, 512);