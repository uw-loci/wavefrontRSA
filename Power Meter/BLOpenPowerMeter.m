function [ s ] = BLOpenPowerMeter( port )
%BLOPENPOWERMETER opens a instance of serial connection.
%   INPUT ARGUMENTS
%   port    e.g. COM3
%
%   OUTPUT ARGUMENTS
%   s       instance of serial connection created

switch nargin 
    case 0
        port = 'COM3';
    case 1
           
    otherwise
        disp('too many input arguments')
end 
       
s = serial(port);
set(s,'Terminator','CR');
set(s,'BaudRate',19200);
set(s,'Parity','none');
set(s,'DataBits',8);
set(s,'StopBits',1);
fopen(s);

end

