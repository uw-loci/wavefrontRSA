function [ move ] = Feedback( E , ImageIndex )
%FEEDBACK accepts E and Image Index. If E(ImageIndex) is the global minimum
%the array E, then move is true. 

move = (E(ImageIndex) == min(E(1:ImageIndex)));

end

