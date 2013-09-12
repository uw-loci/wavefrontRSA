% 
% s = serial('COM3');
% set(s,'Terminator','CR');
% set(s,'BaudRate',19200);
% set(s,'Parity','none');
% set(s,'DataBits',8);
% set(s,'StopBits',1);
% 
% fopen(s);
% 
% fprintf(s,'Dec');
% out1 = fscanf(s);
% 
% fprintf(s, 'Pwr?');
% 
% out2 = fscanf(s);
% 
% 
% fclose(s);
% delete(s);
% clear s


% end
powerMeter = BLOpenPowerMeter('COM3');
tic 
power = BLGetPower(powerMeter);
toc
BLClosePowerMeter(powerMeter);

