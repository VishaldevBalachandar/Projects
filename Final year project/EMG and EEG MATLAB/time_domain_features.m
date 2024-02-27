% Define parameters for feature extraction
window_size = 0.1;  % Window size in seconds
overlap = 0.08;     % Overlapping in seconds

% Convert window size and overlap to sample points
window_size_samples = round(window_size * sampling_frequency);
overlap_samples = round(overlap * sampling_frequency);

% Initialize matrices to store features
num_channels = length(selected_channels);
num_features = 3; % Standard Deviation, Mean Absolute, and Variance
num_windows = floor((length(eeg_time_vector) - window_size_samples) / (window_size_samples - overlap_samples)) + 1;
time_features = zeros(num_windows, num_channels * num_features);

% Loop through selected channel names
for i = 1:num_channels
    channel_name = selected_channels{i};
    
    % Find the index of the channel name in eeg_labels
    channel_index = find(strcmp(eeg_labels, channel_name));
    
    if ~isempty(channel_index)
        % Extract EEG data for the selected channel
        eeg_channel_data = eeg_data(:, channel_index);
        
        % Apply a bandpass filter for the alpha and beta ranges (8-30 Hz)
        filtered_data = bandpass(eeg_channel_data, [8, 30], sampling_frequency);
        
        % Extract features using sliding window
        for window_start = 1:num_windows
            start_idx = (window_start - 1) * (window_size_samples - overlap_samples) + 1;
            end_idx = start_idx + window_size_samples - 1;
            windowed_data = filtered_data(start_idx:end_idx);
            
            % Calculate features for the windowed data
            std_dev = std(windowed_data);
            mean_abs = mean(abs(windowed_data));
            variance = var(windowed_data);
            
            % Store the features in the time_features matrix
            feature_idx = (i - 1) * num_features + 1; % Index for this channel's features
            time_features(window_start, feature_idx) = std_dev;
            time_features(window_start, feature_idx + 1) = mean_abs;
            time_features(window_start, feature_idx + 2) = variance;
        end
    else
        % Handle the case where the channel name is not found
        disp(['EEG Channel ' channel_name ' not found']);
    end
end

% Now time_features contains the extracted time domain features for each window and channel
% You can use these features for classification with a suitable classifier like SVM.
