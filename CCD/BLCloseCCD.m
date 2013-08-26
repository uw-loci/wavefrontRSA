function [  ] = BLCloseCCD( vid )
%BLCLOSECCD closes video object vid 

stop(vid);
delete(vid);
close(gcf);

end

