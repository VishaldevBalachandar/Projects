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

% Define the EEG channels you want to select
eeg_channels_to_select = {'C3', 'C4', 'CP1', 'CP2', 'CP5', 'CP6', 'Cz'};

% Initialize an empty matrix to store selected EEG data
selected_eeg_data = [];

% Loop through selected channel names
for i = 1:length(eeg_channels_to_select)
    channel_name = eeg_channels_to_select{i};
    
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

% Create time vectors
eeg_time_vector = eeg_timestamps - eeg_timestamps(1);

% Plot selected EEG data
figure;
subplot(2,1,1);
plot(eeg_time_vector, selected_eeg_data);
title('EEG Data (Selected Channels)');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

% Add EEG channel labels as legends
legend(eeg_channels_to_select, 'Location', 'Best');

% Extract EMG data
emg_data = ws.win.emg; % Replace 'emg' with actual field name for EMG data
emg_timestamps = ws.win.emg_t;

% Plot EMG data with labels
subplot(2, 1, 2);
plot(emg_time_vector, emg_data);
title('EMG Data');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

% Add EMG channel labels as legends
legend(emg_labels);

% Note: EEG and EMG data are now displayed with selected channels for EEG
% and all channels for EMG.
