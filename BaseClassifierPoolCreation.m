function [BCP,Testingset,Validationset,Extra_info]=BaseClassifierPoolCreation(data,UpperBoundforClustering)

    [Trainingset,Testingset,Validationset]=NCA(data);
    % for ease of computation
    % trainingset1 = trainingset(1:80,:);
    %phase 2-incremental clustering 

    [clusters,~,~,~]=IncrementalKmeansClustering(Trainingset,UpperBoundforClustering);
    % the total number of clusters are 1035
    % in this step we can separate the atomic and non_atomic clusters with
    % atomic function 
    [nonatomic_clusters,atomic_clusters_class0,atomic_clusters_class1] = atomic(clusters); 
    % after this we have three cell arraies (nonatamic_clusters,atomic_clusters_class0,atomic_clusters_class1)
%     [Balance_Clusters,ImBalance_Clusters_0,ImBalance_Clusters_1] = Balance(nonatomic_clusters);
    % Reamove Same Clusters from Our Non Atomic Clusters 
    NACWNEC =nonatomic_clusters;
    for i=1:length(NACWNEC)
        for j=i+1:length(NACWNEC)
            if isequal(NACWNEC{i},NACWNEC{j})
                NACWNEC{j}=[];
            end
        end
    end
    % Balance Clusters With No Equal Clusters
    NACWNEC= NACWNEC(~cellfun('isempty',NACWNEC));
    % phase 3-training all classifiers 
    % 1-ANN classification 
    ANN_classifiers = cell(length(NACWNEC),1);
    % ANN_classification = cell(length(clusters),1);
    for f=1:length(NACWNEC)
       ANN_classifiers{f} = ANN(NACWNEC{f});
    end 
    % for f= 1:length(clusters)
    % ANN_classification{f} = ANN_classifiers{f}.predictFcn(xtest);
    % end 
    % 2-KNN classification 
    KNN_classifiers = cell(length(NACWNEC),1);
    % KNN_classification = cell(length(clusters),1);
    for f = 1:length(NACWNEC)
        KNN_classifiers{f}= KNN(NACWNEC{f});
    end 
    % 3-SVM classification 
    SVM_classifiers = cell(length(NACWNEC),1);
    % SVM_classification = cell(length(clusters),1);
    for f = 1:length(NACWNEC)
        SVM_classifiers{f}= SVM(NACWNEC{f});
    end
    % 4-Decicion Tree classification 
    DT_classifiers = cell(length(NACWNEC),1);
    % DT_classification = cell(length(clusters),1);
    for f = 1:length(NACWNEC)
        DT_classifiers{f}= DT(NACWNEC{f});
    end

    % 5-NB classification
    NB_classifiers = cell(length(NACWNEC),1);
    for f = 1:length(NACWNEC)
        NB_classifiers{f}= NB(NACWNEC{f});
    end
    % attach the classifier's cells together and make the Base Classifier Pool
    BCP = [ANN_classifiers
        KNN_classifiers
        SVM_classifiers
        DT_classifiers
        NB_classifiers];
    
    Extra_info.All_Clusters = clusters;
    Extra_info.atomic_clusters_class0 =atomic_clusters_class0;
    Extra_info.atomic_clusters_class1 =atomic_clusters_class1;
    Extra_info.NonAtomic_Clusters =nonatomic_clusters;
%     Extra_info.Balence_Clusters=Balance_Clusters;
%     Extra_info.ImBalence_Clusters_0=ImBalance_Clusters_0;
%     Extra_info.ImBalence_Clusters_1=ImBalance_Clusters_1;
    Extra_info.NonAtomic_Clusters_with_No_Equal_Clusters=NACWNEC;
    
end 