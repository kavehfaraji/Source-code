function [y1,y2]=UniformCrossover(x1,x2)

    alpha=randi([0 1],size(x1));
    
    for i=1:length(x1)
        if alpha(i,1)==1
            y1{i,1}=x1{i};
            y2{i,1}=x2{i};
        elseif alpha(i,1)==0
            y1{i,1}=x2{i};
            y2{i,1}=x1{i};
        end 
    end 


end 