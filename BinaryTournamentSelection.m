function si = BinaryTournamentSelection(pop)
    
    n = numel(pop);
    
    I = randsample(n,2);

    i1 = I(1);
    i2 = I(2);
    
    p = pop(i1);
    q = pop(i2);
     if Dominates(p,q)
         si = p;
     elseif Dominates(q,p)
         si = q;
     else 
         L=randsample([1 2],1);
         i = I(L);
         si = pop(i);
     end
    
end 