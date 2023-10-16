function [nonatamic_clusters,atomic_clusters_class0,atomic_clusters_class1] = atomic(clusters)
atomic_clusters_class0 =cell(2,1);
atomic_clusters_class1 =cell(2,1);
nonatamic_clusters = cell(2,1);
a=1;
b=1;
c=1;
    for f =1:length(clusters)
        if clusters{f}(:,end)==0
            atomic_clusters_class0{a} = clusters{f}(:,:);
            a=a+1;
        elseif clusters{f}(:,end)==1
            atomic_clusters_class1{b} = clusters{f}(:,:);
            b=b+1;
        else 
            nonatamic_clusters{c} = clusters{f}(:,:);
            c=c+1;
        end 
    end
    
atomic_clusters_class0= atomic_clusters_class0(~cellfun('isempty',atomic_clusters_class0));
atomic_clusters_class1= atomic_clusters_class1(~cellfun('isempty',atomic_clusters_class1));
nonatamic_clusters= nonatamic_clusters(~cellfun('isempty',nonatamic_clusters));

end 
    