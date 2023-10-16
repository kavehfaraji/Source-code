function a=ACCURACY(ensemble_output,yvalidationset)

    [L,~] = size(ensemble_output);
    y = zeros(L,1);
    for i=1:L
        if ensemble_output(i,1)==yvalidationset(i,1)
            y(i) = 1;
        else 
            y(i) = 0;
        end 
    end 
    
a = sum(y)/L;

end 