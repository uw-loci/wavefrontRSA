function [ gauss2D ] = gauss2D(height,width,alpha)
% DESCRIPTION
% GAUSS2D generates a 2D gaussian weight function. The peak of the gaussian
% corresponds to the center of the output matrix. 
% 
% INPUT ARGUMENTS 
%   height    height of the output image 
%   width     width of the output image
%   alpha     the gaussian function becomes thinner as alpha increases. For
%             a complete description use 'help gausswin'. 

gauss_x = gausswin(width,alpha);
gauss2D_x = zeros(height,width);

gauss_y = gausswin(height,alpha);
gauss2D_y = zeros(height,width);

for n = 1:height
    gauss2D_x(n,:) = gauss_x';
end

for n = 1:width
    gauss2D_y(:,n) = gauss_y;
end



gauss2D = gauss2D_x.*gauss2D_y;

end

