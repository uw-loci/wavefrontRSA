function [board] = newboard(tileSize, ntiles, deltaPhase) 
%% generate background
% background = zeros(1024,1024);
%% generate checkerboard
board = checkerboard(tileSize,ntiles,ntiles);

% threshold checkerboard
board = deltaPhase*180*(board > 0.5);

%% pad the board with zeors
% padding = [256 256];
% board = padarray(board,padding);

%% display the board 
% figure(1);
% 
% imagesc(board);
% colorbar;


