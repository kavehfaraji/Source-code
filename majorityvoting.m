function mvoutput = majorityvoting(votes)
mvoutput = zeros(10,1);
% votes = zeros(10,1);
% for i=1:length(xvalidationset)% or 315
%     for m=1:length(predictions)
%         votes(i,m)= predictions{m}(i);
%     end 
% end   
for k=1:size(votes,1)
    mvoutput(k,1)= mode(votes(k,:));
%     if sum(votes(k,:)==1) > sum(votes(k,:)==0)
%         mvoutput(k)= 1;
%     elseif sum(votes(k,:)==1) < sum(votes(k,:)==0)
%         mvoutput(k)=0;
%     elseif sum(votes(k,:)==1) == sum(votes(k,:)==0)
%         mvoutput(k)= "NaN";
%     else 
%         disp('error')
%     end 
end 
end 