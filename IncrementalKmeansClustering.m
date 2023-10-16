function [clusters,C,sumd,D]=IncrementalKmeansClustering(data,upperboundforclustering)
% first you must import the data by yourself
% convert data to matrix or array
data = data{:,:};
% inputs
i = 1; 
d = (length(data)*(length(data)+1))/2;
% initialize a cell array for saving all clusters in it
clusters = cell(d,1);
% generate a "for loop" for incremental k_means clustering 
    for  K=1:upperboundforclustering%length(data)
    [idx,C,sumd,D]=kmeans(data,K);
        for e =1:K
             clusters{i}=data(idx==e,:);
             i = i+1;
        end 
    end 
clusters = clusters(~cellfun('isempty',clusters)); 
end 