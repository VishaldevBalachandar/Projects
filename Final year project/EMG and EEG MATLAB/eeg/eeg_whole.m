% Initialize an empty matrix to store selected EEG data
selected_eeg_data = [];

% Loop through selected channel names
for i = 1:length(selected_channels)
    channel_name = selected_channels{i};
    
    % Find the index of the channel name in eeg_labels
    channel_index = find(strcmp(eeg_labels, channel_name));
    
    if ~isempty(channel_index)
        % Extract EEG data for the selected channel
        channel_data = eeg_data(:, channel_index);
        
        % Store the channel data in the matrix
        selected_eeg_data = [selected_eeg_data, channel_data];
    else
        % Handle the case where the channel name is not found
        disp(['EEG Channel ' channel_name ' not found']);
    end
end

% Plot selected EEG data
figure;
plot(eeg_time_vector, selected_eeg_data);
title('EEG Data (Selected Channels)');
xlabel('t (s)');
ylabel('Amplitude [µV]');
grid on;

% Add EEG channel labels as legends
legend(selected_channels, 'Location', 'Best');
