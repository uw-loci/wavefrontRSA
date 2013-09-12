function [ movie ] = addoneframe( movie, frame, iframe )
%ADDONEFRAME adds one frame to the input argument movie
%   INPUT ARGUMENT
%   movie   current movie
%   frame   frame to be added
%   iframe  frame number of the frame
%
%   OUTPUT ARGUMENT
%   movie   updated movie

amin = 0;
amax = 255;
grayscaleimage = mat2gray(frame,[amin amax]);
imshow(grayscaleimage);
movie(iframe) = getframe(gcf);

end

