function [trainedClassifier] = NB(trainingData)
predictors = trainingData(:,1:8);
response = trainingData(:,end);
% Train a classifier
% This code specifies all the classifier options and trains the classifier.
classificationNaiveBayes = fitcnb(...
    predictors, ...
    response, ...
    'DistributionNames','mn',...
    'ClassNames', [0; 1]);
% Create the result struct with predict function
predictorExtractionFcn = @(x) array2table(x);
naivebaysePredictFcn = @(x) predict(classificationNaiveBayes, x);
trainedClassifier.predictFcn = @(x) naivebaysePredictFcn(predictorExtractionFcn(x));

% Add additional fields to the result struct
trainedClassifier.ClassificationNaiveBayes = classificationNaiveBayes;
end 