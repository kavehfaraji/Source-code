function [Balence_Clusters,ImBalence_Clusters_0,ImBalence_Clusters_1] = Balance(nonatomic_clusters)
Balence_Clusters =cell(1,1);
ImBalence_Clusters_0 =cell(1,1);
ImBalence_Clusters_1 =cell(1,1);
a=1;
b=1;
c=1;

    for f =1:length(nonatomic_clusters)
        if sum(nonatomic_clusters{f}(:,end)==0)== sum(nonatomic_clusters{f}(:,end)==1)
            Balence_Clusters{a,1} = nonatomic_clusters{f}(:,:);
            a=a+1;
        elseif sum(nonatomic_clusters{f}(:,end)==0)>sum(nonatomic_clusters{f}(:,end)==1)
            ImBalence_Clusters_0{b,1} = nonatomic_clusters{f}(:,:);
            b=b+1;
        elseif sum(nonatomic_clusters{f}(:,end)==0)<sum(nonatomic_clusters{f}(:,end)==1)
            ImBalence_Clusters_1{c,1} = nonatomic_clusters{f}(:,:);
            c=c+1;
        end 
    end 
end 
    