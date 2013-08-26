function [ snapshot ] = BLGetImage( vid )
%BLGETIMAGE takes one image using a video object vid
%   INPUT ARGUMENTS
%   vid     a video ojbect 
%
%   OUTPUT ARGUMENTS
%   snapshot    image acquired. 

trigger(vid);
snapshot = getdata(vid);

end

