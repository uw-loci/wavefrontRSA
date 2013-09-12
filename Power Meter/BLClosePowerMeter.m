function [  ] = BLClosePowerMeter( s )
%BLCLOSEPOWERMETER closes serial connection instance s
%   function [  ] = BLClosePowerMeter( s )
%   INPUT ARGUMENTS 
%   s   a serial connection instance 
fclose(s);
delete(s);
clear s

end

