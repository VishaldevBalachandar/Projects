function [confMat, accuracy] = testDatasetSpeakerRecognition(datasetPath)
    trueLabels = {};
    predictedLabels = {};

    % Get a list of all subdirectories (speakers) in the dataset
    speakers = dir(datasetPath);
    speakers = speakers([speakers.isdir] & ~strcmp({speakers.name}, '.' ) & ~strcmp({speakers.name}, '..'));

    % Iterate through each speaker in the dataset
    for i = 1:length(speakers)
        speakerFolder = fullfile(datasetPath, speakers(i).name);

        % Iterate through audio files in the speaker's folder
        audioFiles = dir(fullfile(speakerFolder, '*.wav'));
        for j = 1:length(audioFiles)
            audioFilePath = fullfile(speakerFolder, audioFiles(j).name);

            % Extract speaker label from the file name
            [~, fileBaseName, ~] = fileparts(audioFiles(j).name);
            parts = strsplit(fileBaseName, '_');
            trueLabel = parts{1};

            % Test the speaker recognition system
            result = testSpeakerRecognition(audioFilePath);

            % Append true label and predicted label
            trueLabels = [trueLabels; trueLabel];
            predictedLabels = [predictedLabels; result];
        end
    end

