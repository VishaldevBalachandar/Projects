% Initialize feature matrix to store frequency domain features
num_channels = length(selected_channels);
num_features = 5; % Number of frequency domain features per channel
frequency_features = [];

% Define sliding window parameters
window_size = 0.1; % Window size in seconds
overlap = 0.08;   % Overlapping in seconds

% Convert window size and overlap to sample points
window_size_samples = round(window_size * sampling_frequency);
overlap_samples = round(overlap * sampling_frequency);

% Loop through selected EEG channels
for channel_index = 1:num_channels
    channel_name = selected_channels{channel_index};
    
    % Find the index of the channel name in eeg_labels
    actual_channel_index = find(strcmp(eeg_labels, channel_name));
    
    if ~isempty(actual_channel_index)
        % Extract EEG data for the selected channel
        eeg_channel_data = eeg_data(:, actual_channel_index);
        
        % Calculate the number of windows
        num_windows = floor((length(eeg_channel_data) - window_size_samples) / (window_size_samples - overlap_samples)) + 1;
        
        % Initialize a matrix to store features for this channel
        channel_features = zeros(num_windows, num_features);
        
        % Loop through windows
        for window_start = 1:num_windows
            start_idx = (window_start - 1) * (window_size_samples - overlap_samples) + 1;
            end_idx = start_idx + window_size_samples - 1;
            windowed_data = eeg_channel_data(start_idx:end_idx);
            
            % Apply FFT to compute the frequency domain representation
            fft_result = fft(windowed_data);
            
            % Calculate the power spectral density using Welch's method
            [psd, f] = pwelch(windowed_data, [], [], [], sampling_frequency);
            
            % Calculate sub-band power in alpha (8-12 Hz) and beta (12-30 Hz) frequency bands
            alpha_power = sum(psd(f >= 8 & f <= 12));
            beta_power = sum(psd(f >= 12 & f <= 30));
            
            % Find the frequency with the maximum PSD
            [max_psd, max_psd_idx] = max(psd);
            frequency_with_max_psd = f(max_psd_idx);
            
            % Calculate spectral energy
            spectral_energy = sum(psd);
            
            % Store the computed features for this window
            channel_features(window_start, :) = [alpha_power, beta_power, max_psd, frequency_with_max_psd, spectral_energy];
        end
        
        % Concatenate the channel-specific features with the overall features
        frequency_features = [frequency_features; channel_features];
    else
        % Handle the case where the channel name is not found
        disp(['EEG Channel ' channel_name ' not found']);
    end
end

% Now, frequency_features contains 5 frequency domain features for each window and channel
