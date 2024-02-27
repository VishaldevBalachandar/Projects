% Extract EEG data
eeg_data = ws.win.eeg; % Replace 'eeg' with actual field name for EEG data
eeg_timestamps = ws.win.eeg_t;

% Extract EEG labels
eeg_labels = ws.names.eeg; % EEG channel labels

% Create time vector for EEG
eeg_time_vector = eeg_timestamps - eeg_timestamps(1);

% Define the EEG channels you want to select
selected_channels = {'C3', 'C4', 'CP1', 'CP2', 'CP5', 'CP6', 'Cz'};

% Initialize variables to store EEG data and timestamps for the selected channels
selected_eeg_data = [];
selected_eeg_timestamps = [];

% Loop through the selected EEG channels and extract data
for i = 1:length(selected_channels)
    % Find the index of the selected channel in eeg_labels
    channel_index = find(strcmp(eeg_labels, selected_channels{i}));
    
    % Check if the channel was found
    if ~isempty(channel_index)
        % Extract EEG data for the selected channel
        channel_data = eeg_data(channel_index, :); % Assuming EEG data is stored row-wise
        
        % Append the data and timestamps to the selected EEG data
        selected_eeg_data = [selected_eeg_data; channel_data];
        selected_eeg_timestamps = eeg_timestamps;
    else
        % Display a message if the selected channel was not found
        fprintf('Channel %s not found in the EEG data.\n', selected_channels{i});
    end
end

% Now, selected_eeg_data contains EEG data for the selected channels,
% and selected_eeg_timestamps contains corresponding timestamps.
