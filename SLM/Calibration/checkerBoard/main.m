clc

board = newboard(32,8,1);
illuminatedBoard = illuminate(board,2.5);

ftBoard = ftboard(illuminatedBoard);

figure(1);
imagesc(illuminatedBoard);
colormap gray

figure(2);
imagesc(ftBoard);
axis equal;
colormap gray;
% axis([128,384,128,384])
