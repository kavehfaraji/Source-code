function [OutPut,accuracy]=EnsembleofParetoFront(F1,Testingset)
    a1 = cell(2,1);
    predictions = cell(2,1);
    Testingset = Testingset{:,:};
    xTestingset = Testingset(:,1:end-1);
    yTestingset = Testingset(:,end);
    EnsmbelsVotes = cell(2,1);
    MajorityVotesOfEachEnsemble = cell(2,1);
    MV = cell(1,2);
    for n=1:nPop

        a1{n}=F1(n).Position;

        a1{n} = a1{n}(~cellfun('isempty',a1{n}));

        for i=1:length(a1{n})
            if isfield(a1{n,1}{i,1}, 'ANNclassification')==1
                predictions{n,1}{i,1} = a1{n,1}{i,1}.predictFcn(xTestingset.');
                predictions {n,1}{i,1}= (predictions{n,1}{i,1}).';
                predictions{n,1}{i,1} = round(predictions{n,1}{i,1});
            else 
                predictions{n,1}{i,1} = a1{n,1}{i,1}.predictFcn(xTestingset);
            end 
        end

    EnsmbelsVotes{n} = voting(predictions{n});

    MajorityVotesOfEachEnsemble{n} = majorityvoting(EnsmbelsVotes{n});

        for i=1:length(MajorityVotesOfEachEnsemble)

            MV{1,i}=MajorityVotesOfEachEnsemble{i,1};
        end       
    end 
    MV = cell2mat(MV);
    OutPut = majorityvoting(MV);

    accuracy = Confusion(yTestingset,OutPut);
end 