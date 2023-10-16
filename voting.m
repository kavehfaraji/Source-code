function votes = voting(ensembles_predictions)
ensembles_predictions = ensembles_predictions(~cellfun('isempty',ensembles_predictions));
[M ,~]=size(ensembles_predictions);
S=ensembles_predictions{1};
[I,~]=size(S);
votes = zeros(I,M);
for i=1:I
    for m=1:M
        votes(i,m)= ensembles_predictions{m}(i);
    end 
end    
end