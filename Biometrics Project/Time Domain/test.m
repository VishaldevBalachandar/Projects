% Assuming you have a list of training and testing file paths
trainingFiles = dir('/Users/siddharth/Downloads/speech_commands_v0.02/on/train/*.wav');
testingFiles = dir('/Users/siddharth/Downloads/speech_commands_v0.02/on/test/*.wav');

% Initialize arrays to store features and labels
trainingFeatures = [];
trainingLabels = [];

% Extract features for training set
for i = 1:length(trainingFiles)
    filePath = fullfile(trainingFiles(i).folder, trainingFiles(i).name);
    features = time_domain_classification(filePath);
    trainingFeatures = [trainingFeatures; features];
    trainingLabels = [trainingLabels; 1];  % Label 1 for positive samples
end

% Train a simple model (you can choose a more sophisticated one)
classifier = fitcsvm(trainingFeatures, trainingLabels);

% Initialize arrays for testing
testingFeatures = [];
trueLabels = [];

% Extract features for testing set
for i = 1:length(testingFiles)
    filePath = fullfile(testingFiles(i).folder, testingFiles(i).name);
    features = time_domain_classification(filePath);
    testingFeatures = [testingFeatures; features];
    trueLabels = [trueLabels; 1];  % Assuming all test samples are positive
end

% Predict labels using the trained model
predictedLabels = predict(classifier, testingFeatures);

% Evaluate accuracy
accuracy = sum(predictedLabels == trueLabels) / length(trueLabels);
fprintf('Accuracy: %.2f%%\n', accuracy * 100);
