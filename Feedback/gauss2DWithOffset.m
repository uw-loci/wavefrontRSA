function [ gauss2D ] = gauss2D(height,width,alpha,xshift,yshift)
%GAUSS2D Summary of this function goes here
%   Detailed explanation goes here


gauss_x = gausswin(2*width,alpha);
gauss2D_x = zeros(2*height,2*width);

gauss_y = gausswin(2*height,alpha);
gauss2D_y = zeros(2*height,2*width);

for n = 1:2*height
    gauss2D_x(n,:) = gauss_x';
end

for n = 1:2*width
    gauss2D_y(:,n) = gauss_y;
end



gauss2Dbuf = gauss2D_x.*gauss2D_y;
lbx = width/2 - xshift;
ubx = width/2 + width - xshift;
lby = height/2 - yshift;
uby = height/2 + height - yshift;
gauss2D = gauss2Dbuf(lby:uby, lbx:ubx);
end

