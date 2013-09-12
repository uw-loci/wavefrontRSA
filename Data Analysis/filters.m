function [ ] = filters( imagePath )
%FILTER Summary of this function goes here
%   Detailed explanation goes here
colormap('hot');
colorbar
%% read image 
image = imread(imagePath);
subplot(2,2,1); 
imshow(image); title('Original Image');

colormap('hot');
colorbar

%% median filter
imageMedFilt = medfilt2(image);
subplot(2,2,2); 
imshow(imageMedFilt); title('Median Filtered Image');

colormap('hot');
colorbar

%% gaussian low-pass filter
gaussFilt = fspecial('gaussian');
imageGaussFilt = imfilter(image,gaussFilt);
subplot(2,2,3); 
imshow(imageGaussFilt); title('Gaussian Filtered Image');

colormap('hot');
colorbar

%% filtered with both low-pass and median filters
imageMedGaussFilt = imfilter(imageMedFilt,gaussFilt);
subplot(2,2,4);
imshow(imageMedGaussFilt); title('Median and Gaussian Filtered Image');

colormap('hot');
colorbar

end

