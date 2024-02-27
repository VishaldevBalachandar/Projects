% Extract EEG data
eeg_data = ws.win.eeg; % Replace 'eeg' with actual field name for EEG data
eeg_timestamps = ws.win.eeg_t;

% Extract EEG labels
eeg_labels = ws.names.eeg; % EEG channel labels

% Create time vector for EEG
eeg_time_vector = eeg_timestamps - eeg_timestamps(1);

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
        
        % Apply bandpass filters for the alpha and beta bands
        sampling_frequency = 1000; % Replace with the actual value in Hz
        alpha_range = [8, 13]; % Alpha frequency range (8-13 Hz)
        beta_range = [13, 30]; % Beta frequency range (13-30 Hz)
        
        % Design bandpass filters
        alpha_bandpass = bandpass(channel_data, alpha_range, sampling_frequency);
        beta_bandpass = bandpass(channel_data, beta_range, sampling_frequency);
        
        % Store the filtered channel data in the matrix
        selected_eeg_data = [selected_eeg_data, alpha_bandpass, beta_bandpass];
    else
        % Handle the case where the channel name is not found
        disp(['EEG Channel ' channel_name ' not found']);
    end
end

% Plot selected EEG data
figure;
plot(eeg_time_vector, selected_eeg_data);
title('EEG Data (Alpha and Beta Bands - Selected Channels)');
xlabel('t (s)');
ylabel('Amplitude [mV]');
grid on;

% Add EEG channel labels as legends
% Note: Since you've combined alpha and beta data, consider providing meaningful labels for these combined channels.
legend(eeg_channels_to_select, 'Location', 'Best');
