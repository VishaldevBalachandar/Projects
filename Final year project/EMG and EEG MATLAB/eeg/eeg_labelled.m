% Define the EEG labels for each phase
eeg_phase_labels = {'Resting', 'Extension', 'Lifting', 'Flexion'};

% Create a vector of labels corresponding to EEG data
% You may need to adjust the timestamps and conditions based on your data
eeg_labels_vector = zeros(size(selected_eeg_data, 1), 1);

for i = 1:size(participant_events, 1)
    start_time = participant_events(i, 12); % tIndTouch
    end_time = participant_events(i, 21);   % tIndRelease
    
    start_time_extension = participant_events(i, 16); % Column 16 for extension start time
    end_time_extension = participant_events(i, 19);   % Column 19 for extension end time
    start_time_lifting = participant_events(i, 19);    % Column 19 for lifting start time
    end_time_lifting = participant_events(i, 23);      % Column 23 for lifting end time
    start_time_flexion = participant_events(i, 23);    % Column 23 for flexion start time
    end_time_flexion = participant_events(i, 35);      % Column 35 for flexion end time
    
    % Determine the phase based on timestamps (adjust as needed)
    if any(eeg_time_vector >= start_time & eeg_time_vector <= end_time)
        phase_index = find(eeg_time_vector >= start_time & eeg_time_vector <= end_time, 1);
        eeg_labels_vector(phase_index) = 1; % Resting
    elseif any(eeg_time_vector >= start_time_extension & eeg_time_vector <= end_time_extension)
        phase_index = find(eeg_time_vector >= start_time_extension & eeg_time_vector <= end_time_extension, 1);
        eeg_labels_vector(phase_index) = 2; % Extension
    elseif any(eeg_time_vector >= start_time_lifting & eeg_time_vector <= end_time_lifting)
        phase_index = find(eeg_time_vector >= start_time_lifting & eeg_time_vector <= end_time_lifting, 1);
        eeg_labels_vector(phase_index) = 3; % Lifting
    elseif any(eeg_time_vector >= start_time_flexion & eeg_time_vector <= end_time_flexion)
        phase_index = find(eeg_time_vector >= start_time_flexion & eeg_time_vector <= end_time_flexion, 1);
        eeg_labels_vector(phase_index) = 4; % Flexion
    end
end

% Create a figure
figure;

% Plot the selected EEG data with color-coded segments for each phase
for phaseIdx = 1:max(eeg_labels_vector)
    subplot(2, 1, 1);
    % Filter the EEG data based on the current phase label
    eeg_segment = selected_eeg_data(eeg_labels_vector == phaseIdx, :);
    time_segment = eeg_time_vector(eeg_labels_vector == phaseIdx);
    % Plot the segment with a unique color for each phase
    plot(time_segment, eeg_segment, 'Color', custom_colors(phaseIdx, :));
    hold on; % Hold the plot for multiple segments
end
hold off; % Release the hold

title('EEG Data with Custom Color-Coded Labels');
xlabel('Time (seconds)');
ylabel('Amplitude');
grid on;

% Plot the phase labels
subplot(2, 1, 2);
plot(eeg_time_vector, eeg_labels_vector, 'k'); % Black color for labels
title('Phase Labels');
xlabel('Time (seconds)');
ylabel('Phase');
grid on;

% Add EEG channel labels as legends (similar to EMG)
legend(eeg_channels_to_select, 'Location', 'Best');

% Add EEG phase labels as additional legends
legend(eeg_phase_labels, 'Location', 'Best');
