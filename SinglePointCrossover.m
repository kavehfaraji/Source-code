function [y1,y2]=SinglePointCrossover(x1,x2)

    nVar=numel(x1);
    
    cutpoint=randi([1 nVar]);
    
    y1=[x1(1:cutpoint)
        x2(cutpoint+1:end)];
    y2=[x2(1:cutpoint)
        x1(cutpoint+1:end)];

end 