function [logAbsFourierBoard] = ftboard(board)
%% take fft
fourierBoard = fftn(board);
% figure;
absFourierBoard = abs(fftshift(fourierBoard));
logAbsFourierBoard = absFourierBoard;
% imagesc(logAbsFourierBoard);
% colormap('gray');
end
