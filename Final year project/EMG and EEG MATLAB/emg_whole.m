% Get the number of channels
num_channels = size(emg_data, 2);

% Define a color map for differentiating channels
color_map = lines(num_channels);

% Create a new figure for all channels together
figure(1);

% Plot the EMG signals for all channels with different colors
for channel_number = 1:num_channels
    % Get the corresponding muscle label from the muscle_labels array
    if channel_number <= length(muscle_labels)
        muscle_label = muscle_labels{channel_number};
    else
        muscle_label = 'Unknown';
    end
    
    % Plot the EMG signal for the current channel with a different color
    hold on;  % Hold the plot to overlay all channels
    plot(emg_timestamps, emg_data(:, channel_number), 'Color', color_map(channel_number, :));
end

% Add a title and labels to the figure
title(['Labelled EMG Signals for Trial ' num2str(trial)]);
xlabel('t [s]');
ylabel('Amplitude [mV]');
grid on;

% Create a legend to label each channel with its corresponding muscle label
legend(muscle_labels, 'Location', 'Best');

% Release the hold on the plot
hold off;