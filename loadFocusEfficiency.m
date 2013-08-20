file = dlmread('C:\Documents and Settings\zeeshan\Desktop\reflectance0812\RTratio.txt');
plot(file(:,5),'r')
hold on 
plot(file(:,6),'g')
plot(file(:,7),'k')
legend('Current Reflectance','Best Reflectance','Control')