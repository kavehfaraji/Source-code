% NCA function 
function [trainingset,testingset,validationset]=NCA(data)
% split independent and dependet variables 
x = data(:,1:11);
y = data(:,end);
% convert those tables to matrices 
x = x{:,:};
y = y{:,:};
% split the data to train and test set 
rng(1);
cvp = cvpartition(3150,'holdout',30/100); 
x_train = x(cvp.training,:);
y_train = y(cvp.training,:);
x_test = x(cvp.test,:);
y_test = y(cvp.test,:);
% Use NCA to select features with more importance 
% first determine if feature selection is necessary
% Compute generalization error without fitting
% ncamodel = fscnca(x_train,y_train, 'FitMethod','none');
% L = loss(ncamodel,x_test, y_test); % L = 0.1058
% Fit NCA without regularization parameter
% ncamodel = fscnca(x_train,y_train,'FitMethod','exact','Lambda',0,'Solver','sgd','Standardize',true);
% L = loss(ncamodel,x_test,y_test); % L = 0.0529 
% The improvement on the loss value suggests that feature selection is a good idea
% tuning the lambda value 
% Tune the regularization parameter for NCA using five-fold cross-validation
cvp = cvpartition(y_train,'kfold',5);
numtestset = cvp.NumTestSets;
% Assign LAMBDA values and create an array to store the loss function values.
n = length(y_train);
lambdavalues = linspace(0,20,20)/n;
lossvals = zeros(length(lambdavalues),numtestset);
% Train the NCA model for each  value, using the training set in each fold.
% Compute the classification loss for the corresponding test set in the fold using the NCA model. Record the loss value.
% Repeat this process for all folds and all  values.
for i = 1:length(lambdavalues)
    for k = 1:numtestset
        x = x_train(cvp.training(k),:);
        y = y_train(cvp.training(k),:);
        xtest = x_train(cvp.test(k),:);
        ytest = y_train(cvp.test(k),:);
        nca = fscnca(x,y,'FitMethod','exact','solver','sgd','Lambda',lambdavalues(i),'IterationLimit',30,'GradientTolerance',1e-4, 'Standardize',true);
        lossvals(i,k)= loss(nca, xtest,ytest,'LossFunction','classiferror');
    end
end
% Compute the average loss obtained from the folds for each Lambda value
meanloss = mean(lossvals,2);
% Plot the average loss values versus the lambda values
% figure()
% plot(lambdavalues,meanloss,'ro-')
% xlable('lambda')
% ylable('loss (MSE)')
% grid on 
% Find the best lambda value that corresponds to the minimum average loss
[~,idx] = min(meanloss); % Find the index;
bestlambda = lambdavalues(idx); % Find the best lambda value;
% bestloss = meanloss(idx);
% Fit the nca model on all data using best  and plot the feature weights
% Use the solver lbfgs and standardize the predictor values
nca = fscnca(x_train,y_train,'FitMethod','exact','Solver','sgd','Lambda',bestlambda,'Standardize',true,'Verbose',1);
% Plot the feature weights
figure()
plot(nca.FeatureWeights,'ro')
xlabel('Feature index')
ylabel('Feature weight')
grid on
% Select features using the feature weights and a relative threshold
tol    = 0.02;
selidx = find(nca.FeatureWeights > tol*max(1,max(nca.FeatureWeights)));
% Compute the classification loss using the test set
% L = loss(nca,x_test,y_test); % L = 0.0360
% Extract the features with feature weights greater than 0 from the training data
x_train = x_train(:,selidx);
x_test = x_test(:,selidx);

%%%%%%%%%%%%%%%%%%%%%%%%%%%% ADD CLASSES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% first add class labels again
trainingset = [x_train y_train];
testingset = [x_test y_test];
%%%%%%%%%%%%%%%%%%%%%%%%%%%% validation set %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cvp = cvpartition(945,'holdout',1/3);
validationset = testingset(cvp.test,:);
testingset = testingset(cvp.training,:);
%%%%%%%%%%%%%%%%%%%%%%%%%%%  save the data  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% then convert array to tables and then change the variable names to
% original names
% training set 
trainingset = array2table(trainingset,'VariableNames',{'CallFailure','Complains','SubscriptionLength','SecondsOfUse','FrequencyOfUse','DistinctCalledNumbers','AgeGroup','Status','class'});
% writetable(trainingset,'Training_set.xlsx','WriteVariableNames',true);
% and test set 
testingset = array2table(testingset,'VariableNames',{'CallFailure','Complains','SubscriptionLength','SecondsOfUse','FrequencyOfUse','DistinctCalledNumbers','AgeGroup','Status','class'});
% writetable(testingset,'Test_set.xlsx','WriteVariableNames',true);
% and validation set 
validationset = array2table(validationset,'VariableNames',{'CallFailure','Complains','SubscriptionLength','SecondsOfUse','FrequencyOfUse','DistinctCalledNumbers','AgeGroup','Status','class'});
% writetable(validationset,'Validation_set.xlsx','WriteVariableNames',true);
end
