function y=Mutate(x,BCP,mu)

nVar=numel(x);              % Size of Chromosome 
nMu=ceil(mu*nVar);          % Number of Genes that We will Do Mutaion on Them 


i = randsample(nVar,nMu);
j = randsample(length(BCP),nMu);
y = x;
    for L=1:length(i) % or nMu
        p = i(L,1);
        q = j(L,1);
        if isempty(y{p})
            y{p}=BCP{q};
        else 
            y{p}=[];
        end 
%         y{p}=[];
%         y{p}=BCP{q};
    end 
%     y(j)=x(j)+sigma*randn(size(j));   
end 
