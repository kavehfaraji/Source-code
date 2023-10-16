function [trainedClassifier] = ANN(trainingData)
predictors = trainingData(:,1:end-1);
response = trainingData(:,end);
% for ANN first we must Transpose the input data
predictors = predictors.';
response = response.';
% Train a classifier
% train the net for the loop 
% Create a Pattern Recognition Network
trainFcn = 'trainscg';
hiddenLayerSize = 10;    
net = patternnet(hiddenLayerSize, trainFcn);
% then train the net with our data
predictFcn = train(net,predictors,response);
% make a structure for saving the classification results and the trained
% classifier
trainedClassifier.ANNclassification = round(predictFcn(predictors));
trainedClassifier.predictFcn = predictFcn;
% Add additional fields to the result struct
trainedClassifier.ANNclassification = trainedClassifier.ANNclassification;
end 

