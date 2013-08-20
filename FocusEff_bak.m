function [ E ] = FocusEff_bak( snapshot )
%FocusEff calculates Intensity(center)/Intensity(periphery) of the input
%image and output the efficiency as E. 

[height, width] = size(snapshot);

cwidth = round(width/10); % center width
cheight = round(height/10); % center height

Icenter = 0; % center intensity
I = 0; % overall intensity


% calculate center intensity
for n = ceil(width/2 - cwidth/2) : floor(width/2 + cwidth/2)
    for m =  ceil(height/2 - cheight/2) : floor(height/2 + cheight/2)
        Icenter = Icenter + double(snapshot(m,n));
    end
end

% calculate overall intensity
for n = 1 : width
    for m =  1 : height
        I = I + double(snapshot(m,n));
    end
end

E = Icenter/I;

end

