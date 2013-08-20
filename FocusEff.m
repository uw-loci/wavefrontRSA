function [ E ] = FocusEff( snapshot )
%FocusEff calculates Intensity(center)/Intensity(periphery) of the input
%image and output the efficiency as E. 

% E = sum(sum(double(snapshot).*weightingMatrix))/sum(sum(snapshot));
E = sum(sum(snapshot));

end

