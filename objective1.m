function A=objective1(ensemble,Validationset)
    
    ensemble = ensemble(~cellfun('isempty',ensemble));
    Validationset = Validationset{:,:};
    xvalidationset= Validationset(:,1:8);
    yvalidationset= Validationset(:,end);
    ensembles_predictions = cell(1,1);
    s=length(ensemble);
    if s==0 
        A = 1;
    else  
        for k=1:s
            if isfield(ensemble{k}, 'ANNclassification')==1
                ensembles_predictions{k,1} = ensemble{k}.predictFcn(xvalidationset.');
                ensembles_predictions {k,1}= (ensembles_predictions{k,1}).';
                ensembles_predictions{k,1} = round(ensembles_predictions{k,1});
            else
                ensembles_predictions{k,1} = ensemble{k}.predictFcn(xvalidationset);
            end 
        end 

        % Voting
        votes = voting(ensembles_predictions);

        ensemble_output = majorityvoting(votes);

        A=1-(ACCURACY(ensemble_output,yvalidationset));
    end 
end 