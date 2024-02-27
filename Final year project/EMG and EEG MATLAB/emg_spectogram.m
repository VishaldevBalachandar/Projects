% Get the number of channels
num_channels = size(emg_data, 2);

% Loop through each channel and create separate figures for spectrograms
for channel_number = 1:num_channels
    
    % Create a new figure for the current channel's spectrogram
    figure;
    
    % Get the corresponding muscle label from the muscle_labels array
    if channel_number <= length(muscle_labels)
        muscle_label = muscle_labels{channel_number};
    else
        muscle_label = 'Unknown';
    end
    
    % Compute and plot the spectrogram for the current channel
    spectrogram(emg_data(:, channel_number), 512, 50, 2048, 4000, 'yaxis');
    title(['Spectrogram for Trial ' num2str(trial) ' - Muscle: ' muscle_label]);
    xlabel('t [s]');
    ylabel('Frequency [Hz]');
    colorbar;
end
