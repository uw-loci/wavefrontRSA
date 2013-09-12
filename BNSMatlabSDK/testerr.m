try 
    for i = 1:10
        disp(1,1)
    end
catch exception
    errorMessage = sprintf('Error in myScrip.m.\nThe error reported by MATLAB is:\n\n%s', exception.message);
    disp(errorMessage);
    
end 
