function [ phasemaskmovie ] = phasemaskmovie( tilesidelength, phasestepsize, phasemask, avifilename )
%PHASEMASKMOVIE generates a movie of consecutive phase masks displayed on the
%SLM.
% 
%   INPUT ARGUMENT 
%   tilesidelength  side length of the tile 
%   phasestepsize   size of one phase step
%   phasemask(opt.) the final/optimized phase mask. The default phase mask
%   is one with all maximum phase in every pixel.
% 
%   OUTPUT ARGUMENT
%   phasemaskmovie  movie generated from consecutive phasemasks. 



upperbound = 1;
lowerbound = 512;
leftbound = 1;
rightbound = 512;
phasebound = 255;
figure;
imagedata = zeros(512,512);
iframe = 1;

nrows = lowerbound/tilesidelength;
ncols = rightbound/tilesidelength;
nsteps = ceil(phasebound/phasestepsize);
nframes = nrows * ncols * nsteps; 
phasemaskmovie(nframes) = struct('cdata',[],'colormap',[]);


if nargin < 3;
    maxphase = floor(phasebound/phasestepsize) * phasestepsize;
    phasemask = ones(512,512)* maxphase;
end 
for irow = upperbound:tilesidelength:lowerbound    
    heightinterval = irow:irow+tilesidelength-1;
    
    for icol = leftbound:tilesidelength:rightbound        
        widthinterval = icol:icol+tilesidelength-1;
        
        for phase = 0:phasestepsize:phasebound
            imagedata(heightinterval,widthinterval) = phase;            
            phasemaskmovie = addoneframe(phasemaskmovie,imagedata, iframe);
            iframe = iframe + 1;
        end
        
        imagedata(heightinterval,widthinterval) = phasemask(heightinterval,widthinterval);
        phasemaskmovie = addoneframe(phasemaskmovie, imagedata, iframe);
        iframe = iframe + 1;    
        
    end
end

if nargin == 4
    movie2avi(phasemaskmovie, avifilename);
end 
end

