% Initialize a cell array to store DWT features for all channels
dwt_features = cell(1, num_channels);

% Initialize a variable to count the total number of features
total_features_extracted = 0;

% Loop through selected EEG channels
for channel_index = 1:num_channels
    channel_name = selected_channels{channel_index};
    
    % Find the index of the channel name in eeg_labels
    channel_index_eeg = find(strcmp(eeg_labels, channel_name));
    
    if ~isempty(channel_index_eeg)
        % Extract EEG data for the selected channel
        eeg_channel_data = eeg_data(:, channel_index_eeg);
        
        % Initialize matrices to store DWT coefficients for this channel
        cA_coeffs = [];
        cD_coeffs = [];
        
        % Loop through the EEG data using the sliding window
        for window_start = 1:overlap_samples:length(eeg_channel_data) - window_size_samples + 1
            % Extract a window of EEG data
            windowed_data = eeg_channel_data(window_start:window_start + window_size_samples - 1);
            
            % Perform the DWT on the windowed EEG data
            [cA, cD] = dwt(windowed_data, 'db4'); % Adjust the wavelet type as needed
            
            % Store the DWT coefficients for this window
            cA_coeffs = [cA_coeffs; cA];
            cD_coeffs = [cD_coeffs; cD];
        end
        
        % Store the DWT features (cA and cD) for this channel in the cell array
        dwt_features{channel_index} = [cA_coeffs, cD_coeffs];
        
        % Update the total number of features
        total_features_extracted = total_features_extracted + size(dwt_features{channel_index}, 2);
    else
        % Handle the case where the channel name is not found
        disp(['EEG Channel ' channel_name ' not found']);
    end
end

% Check if exactly 14 features have been extracted
if total_features_extracted == 14
    disp('Successfully extracted 14 features.');
else
    disp(['Extracted ' num2str(total_features_extracted) ' features.']);
end

% Now, dwt_features is a cell array containing DWT features for all channels
