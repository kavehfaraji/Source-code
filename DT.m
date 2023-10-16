function [trainedClassifier] = DT(trainingData)
predictors = trainingData(:, 1:8);
response = trainingData(:,end); 
% Train a classifier
% This code specifies all the classifier options and trains the classifier.
classificationTree = fitctree(...
    predictors, ...
    response, ...
    'SplitCriterion', 'gdi', ...
    'MaxNumSplits', 100, ...
    'Surrogate', 'off', ...
    'ClassNames', [0; 1]);
% Create the result struct with predict function
predictorExtractionFcn = @(x) array2table(x);
treePredictFcn = @(x) predict(classificationTree, x);
trainedClassifier.predictFcn = @(x) treePredictFcn(predictorExtractionFcn(x));

% Add additional fields to the result struct
trainedClassifier.ClassificationTree = classificationTree;

end
