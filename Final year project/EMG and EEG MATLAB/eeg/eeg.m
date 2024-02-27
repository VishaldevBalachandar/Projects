% Loop through selected channel names
for i = 1:length(selected_channels)
    channel_name = selected_channels{i};
    
    % Find the index of the channel name in eeg_labels
    channel_index = find(strcmp(eeg_labels, channel_name));
    
    if ~isempty(channel_index)
        % Extract EEG data for the selected channel
        channel_data = eeg_data(:, channel_index);
        % Create a new figure for each channel
        figure;
        plot(eeg_time_vector, channel_data);
        title(['EEG Channel ' channel_name]);
        xlabel('t (s)');
        ylabel('Amplitude [µV]'); 
        grid on;
    else
        % Handle the case where the channel name is not found
        disp(['EEG Channel ' channel_name ' not found']);
    end
end
