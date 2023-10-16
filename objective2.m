function D = objective2(ensemble,Validationset)

    Validationset = Validationset{:,:};
    ensemble = ensemble(~cellfun('isempty',ensemble));
    xvalidationset= Validationset(:,1:end-1);
%     yvalidationset= validationset(:,end);
    ensembles_predictions = cell(2,1);
    s=length(ensemble);
    if s==0
        D =1;
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

    %     find out the diversity in the ensemble 
       D = 1-(diversity2(ensembles_predictions));
    end 
end    