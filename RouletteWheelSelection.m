function i=RouletteWheelSelection(P1,P2)

    P=(P1+P2)/2;

    r=rand;
    
    C=cumsum(P);
    
    i=find(r<=C,1,'first');

end