% Extract relevant lift events for the participant
participant_events = P.AllLifts(P.AllLifts(:, 1) == participant_number, :);

% Define the labels for each stage
labels = zeros(size(emg_data, 1), 1); % Initialize labels
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


% Define a custom color palette with darker colors
custom_colors = [
    0.7 0.2 0.2; % Darker Red
    0.2 0.7 0.2; % Darker Green
    0.2 0.2 0.7; % Darker Blue
    0.7 0.7 0.2  % Darker Yellow
];

% Define labels for legend in the first subplot
legend_labels = {'Resting', 'Extension', 'Lifting', 'Flexion'};

% Create a figure
figure();

% Initialize legend handles for the first subplot
legend_handles = [];

% Define the line width for the legend entries
line_width = 2; % Adjust this value to change the line thickness

% Plot the EMG signal with custom color-coded segments for each label
for labelIdx = 1:max(labels)
    subplot(2, 1, 1);
    % Filter the EMG data based on the current label
    emg_segment = emg_data(labels == labelIdx, :);
    timestamps_segment = emg_timestamps(labels == labelIdx);
    % Plot the segment with the corresponding custom color and label
    plot(timestamps_segment, emg_segment, 'Color', custom_colors(labelIdx, :));
    hold on; % Hold the plot for multiple segments
    % Create a legend entry for this label with specified line width
    legend_handles(labelIdx) = plot(NaN, NaN, 'Color', custom_colors(labelIdx, :), 'DisplayName', legend_labels{labelIdx}, 'LineWidth', line_width);
end
hold off; % Release the hold

title('EMG Signal with Custom Color-Coded Labels');
xlabel('t [s]');
ylabel('Amplitude [mV]');
grid on;

% Add a legend with a single entry per color in the first subplot
legend(legend_handles, 'Location', 'Best', 'FontSize', 14);

% Plot the labels in the second subplot without a legend
subplot(2, 1, 2);
plot(emg_timestamps, labels, 'k'); % Black color for labels
title('Labels');
xlabel('t [s]');
ylabel('Phase Label');
grid on;

% Add text annotations to indicate the meaning of phase labels
text(0.1, max(labels) - 3, ' Resting', 'Color', 'k');
text(0.1, max(labels) - 2, ' Extension', 'Color', 'k');
text(0.1, max(labels) - 1, ' Lifting', 'Color', 'k');
text(0.1, max(labels), ' Flexion', 'Color', 'k');

% Link the x-axis (time axis) between the two subplots
linkaxes([subplot(2, 1, 1), subplot(2, 1, 2)], 'x');





