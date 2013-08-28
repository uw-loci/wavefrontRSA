function [] = plotData(absolutePath)
% DESCRIPTION
% plotData plots file specified by absolutePath. 
% 
% TODO
% find a way to delete first line containing strings. 
file = dlmread(absolutePath);
plot(file(:,5),'r')
hold on 
plot(file(:,6),'g')
plot(file(:,7),'k')
legend('Current Reflectance','Best Reflectance','Control')
end