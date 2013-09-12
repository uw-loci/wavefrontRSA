
function ImageData = Get512Zernike(ZernikeNum)
%==========================================================================
%=   FUNCTION: ImageData = Get512Zernike(ZernikeNum)
%=
%=   PURPOSE: Generates a 512x512 matrix containing a Zernike phase
%=             pattern.  The pattern is scaled between the values of 
%=             0 and 255.
%=
%=   INPUTS:  Zernike Num - an integer in the range of 0-8 where 
%=              0 = PISTON
%=              1 = POWER
%=              2 = ASTIG X
%=              3 = ASTIG y
%=              4 = COMA X
%=              5 = COMA Y
%=              6 = PRIMARY SPHERICAL
%=
%=  OUTPUTS:  ImageData - a 512x512 array of integers in the range of 0..255.
%=
%==========================================================================
ImageData = ones(512,512);
if     ZernikeNum == 0      % PISTON
    ImageData = imread('C:\BNSMatlabSDK\Image_Files\BLANK.bmp','bmp');
elseif ZernikeNum == 1      % Power
    ImageData = imread('C:\BNSMatlabSDK\Image_Files\Power.bmp','bmp');
elseif ZernikeNum == 2      % Astig X
    ImageData = imread('C:\BNSMatlabSDK\Image_Files\AstigX.bmp','bmp');     
elseif ZernikeNum == 3      % Astig Y
    ImageData = imread('C:\BNSMatlabSDK\Image_Files\AstigY.bmp','bmp'); 
elseif ZernikeNum == 4      % Coma X
    ImageData = imread('C:\BNSMatlabSDK\Image_Files\ComaX.bmp','bmp');
elseif ZernikeNum == 5      % Coma Y
    ImageData = imread('C:\BNSMatlabSDK\Image_Files\ComaY.bmp','bmp');
elseif ZernikeNum == 6      % Primary Spherical
    ImageData = imread('C:\BNSMatlabSDK\Image_Files\PrimarySpherical.bmp','bmp'); 
end
