% Get the number of channels
num_channels = size(emg_data, 2);

dark_green = [0 0.5 0];

% Loop through each channel and create separate figures
for channel_number = 1:num_channels
    
    % Create a new figure for the current channel
    figure;
    
    % Get the corresponding muscle label from the muscle_labels array
    if channel_number <= length(muscle_labels)
        muscle_label = muscle_labels{channel_number};
    else
        muscle_label = 'Unknown';
    end
    
    % Plot the EMG signal for the current channel with dark green color
    plot(emg_timestamps, emg_data(:, channel_number), 'Color', dark_green);
    
    % Add a title and labels to the figure
    title(['EMG Signal for Trial ' num2str(trial) ' - Muscle: ' muscle_label]);
    xlabel('t [s]');
    ylabel('Amplitude [mV]');
    grid on;
end
