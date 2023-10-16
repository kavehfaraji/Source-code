function a = diversity2(ensembles_predictions)

    Comparison = cell(2,1);
    diversitypercentage = zeros(2,1);
    
    k=length(ensembles_predictions);
    %    x=sum(1:k-1);
        p=1;
        b=k;
        z=1;
        while b>1
            Comparison{z,1}= compare(ensembles_predictions{b},ensembles_predictions{b-p});  
            p=p+1;
            if b==p
                p=1;
                b=b-1;
            end 
            z=z+1;
        end 
        for k=1:length(Comparison)
            diversitypercentage(k)=(sum(Comparison{k}))/length(Comparison{k});
        end 
     a = mean(diversitypercentage); 
end 