% Load EMG data
data_directory = '/Users/siddharth/Documents/MATLAB/project/P/';
participant_number = 1;
series_number = 1;
trial = 1;

file_name_ws = sprintf('WS_P%d_S%d.mat', participant_number, series_number);
full_file_path_ws = fullfile(data_directory, file_name_ws);
load(full_file_path_ws);

file_name_lifts = sprintf('P%d_AllLifts.mat', participant_number);
full_file_path_lifts = fullfile(data_directory, file_name_lifts);
load(full_file_path_lifts);

% Extract relevant EMG data
fs = 4000;
emg_data = ws.win(trial).emg;
emg_timestamps = ws.win(trial).emg_t;
muscle_labels = ws.names.emg;

% Save the raw EMG data and labels
save('raw_emg_data.mat', 'emg_data');
save('muscle_labels.mat', 'muscle_labels');

% Filter the EMG data
den = [1.0000, 5.9519, 6.4455, 1.5103];
nyquist_frequency = 1 / (2 * max(den));
low_cutoff_normalized = 0.02;
high_cutoff_normalized = 0.4;

if high_cutoff_normalized > nyquist_frequency
    high_cutoff_normalized = nyquist_frequency - 0.01;
end

[b, a] = butter(4, [low_cutoff_normalized, high_cutoff_normalized], 'bandpass');
filtered_emg_data = filtfilt(b, a, emg_data);

% Rectify the signal
rectified_emg_data = abs(filtered_emg_data);

% Apply a digital low-pass filter to obtain the "linear envelope" of the signal
passband_frequency = 0.2 * nyquist_frequency;
linear_envelope = lowpass(rectified_emg_data, passband_frequency, nyquist_frequency);

% Extract features
extract_features = @(signal) [...
    mean(abs(signal)),...
    sum(abs(diff(signal))),...
    sum(diff(signal > 0)),...
    mean(abs(diff(signal)))
];

% Initialize matrices to store features and labels
num_samples = size(linear_envelope, 1);
num_channels = size(linear_envelope, 2);

features_matrix = zeros(num_samples, 4 * num_channels); % 4 features per channel
labels = zeros(num_samples, 1); % Initialize labels

participant_events = P.AllLifts(P.AllLifts(:, 1) == participant_number, :);

% Label the movements based on participant events
for i = 1:size(participant_events, 1)
    start_time = participant_events(i, 12); % tIndTouch
    end_time = participant_events(i, 21);   % tIndRelease
    
    % Label the corresponding EMG data segments
    % You may need to adjust the timestamps and conditions based on your data
    resting_indices = emg_timestamps >= start_time & emg_timestamps <= end_time;
    labels(resting_indices) = 1; % Resting
    
    % Extension timestamps
    start_time_extension = participant_events(i, 16); % Column 16 for extension start time
    end_time_extension = participant_events(i, 19);   % Column 19 for extension end time
    extension_indices = emg_timestamps >= start_time_extension & emg_timestamps <= end_time_extension;
    labels(extension_indices) = 2; % Extension
    
    % Lifting timestamps
    start_time_lifting = participant_events(i, 19);    % Column 19 for lifting start time
    end_time_lifting = participant_events(i, 23);      % Column 23 for lifting end time
    lifting_indices = emg_timestamps >= start_time_lifting & emg_timestamps <= end_time_lifting;
    labels(lifting_indices) = 3; % Lifting
    
    % Flexion timestamps
    start_time_flexion = participant_events(i, 23);    % Column 23 for flexion start time
    end_time_flexion = participant_events(i, 35);      % Column 35 for flexion end time
    flexion_indices = emg_timestamps >= start_time_flexion & emg_timestamps <= end_time_flexion;
    labels(flexion_indices) = 4; % Flexion
end

% Extract features for each channel and concatenate into the features matrix
for channel_number = 1:num_channels
    try
        current_features = extract_features(linear_envelope(:, channel_number));
        current_features = reshape(current_features, [], 1); % Reshape to a column vector
    catch
        warning('Error during feature extraction. Setting features to zeros.');
        current_features = zeros(4, 1);
    end

    features_start_idx = (channel_number - 1) * 4 + 1;
    features_end_idx = channel_number * 4;

    features_matrix(:, features_start_idx:features_end_idx) = repmat(current_features, 1, num_samples).'; % Transpose for correct assignment
    % Display the extracted features for the current channel
    disp(['Features for Channel ' num2str(channel_number) ':']);
    disp(current_features);
end

% Save the features matrix
save('features_matrix.mat', 'features_matrix');

% Train SVM classifier
svm_model = fitcecoc(features_matrix, labels);

% Save the SVM model
save('svm_model.mat', 'svm_model');

% Visualize the features
figure;
scatter3(features_matrix(:, 1), features_matrix(:, 2), features_matrix(:, 3), 50, labels, 'filled');
title('Visualization of Extracted Features');
xlabel('Feature 1');
ylabel('Feature 2');
zlabel('Feature 3');
colorbar;

% Visualize SVM decision boundary in 3D (assuming 3 features)
if size(features_matrix, 2) == 3
    figure;
    svmStruct = fitcsvm(features_matrix, labels, 'ShowPlot', true);
    title('SVM Decision Boundary and Support Vectors');
    xlabel('Feature 1');
    ylabel('Feature 2');
    zlabel('Feature 3');
    view(-30, 30);  % Adjust the view angle as needed
end

disp('SVM Training Complete.');
