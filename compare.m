 function [compare] = compare(realoutput,classifieroutput)
compare =zeros(length(realoutput),1);
    for i=1:length(realoutput)
        compare(i)= com(realoutput(i),classifieroutput(i));
    end 
 end