% Extract EEG and EMG data
eeg_data = ws.win.eeg; % Replace 'eeg' with actual field name for EEG data
eeg_timestamps = ws.win.eeg_t;

emg_data = ws.win.emg; % Replace 'emg' with actual field name for EMG data
emg_timestamps = ws.win.emg_t;

% Extract EEG and EMG labels
eeg_labels = ws.names.eeg; % EEG channel labels
emg_labels = ws.names.emg; % EMG channel labels


% Create time vectors
eeg_time_vector = eeg_timestamps - eeg_timestamps(1);
emg_time_vector = emg_timestamps - emg_timestamps(1);

% Plot EEG and EMG data side by side with labels
figure;

% Plot EEG data with labels
subplot(2, 1, 1);
plot(eeg_time_vector, eeg_data);
title('EEG Data');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

% Add EEG channel labels as legends
legend(eeg_labels);

% Plot EMG data with labels
subplot(2, 1, 2);
plot(emg_time_vector, emg_data);
title('EMG Data');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

% Add EMG channel labels as legends
legend(emg_labels);
