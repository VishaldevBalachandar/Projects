% Define the alpha and beta frequency ranges
alpha_range = [8, 13]; % Alpha frequency range (8-13 Hz)
beta_range = [13, 30]; % Beta frequency range (13-30 Hz)

% Loop through selected channel names
for i = 1:length(selected_channels)
    channel_name = selected_channels{i};
    
    % Find the index of the channel name in eeg_labels
    channel_index = find(strcmp(eeg_labels, channel_name));
    
    if ~isempty(channel_index)
        % Extract EEG data for the selected channel
        eeg_channel_data = eeg_data(:, channel_index);
        
        % Apply a bandpass filter for the alpha and beta ranges (8-30 Hz)
        filtered_data = bandpass(eeg_channel_data, [8, 30], sampling_frequency);
        
        % Create a new figure for each channel's filtered EEG data
        figure;
        plot(eeg_time_vector, filtered_data, 'b');
        title(['Filtered EEG Channel ' channel_name]);
        xlabel('t (s)');
        ylabel('Amplitude [µV]');
        grid on;
    else
        % Handle the case where the channel name is not found
        disp(['EEG Channel ' channel_name ' not found']);
    end
end
