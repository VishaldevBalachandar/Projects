% Extract EEG data
eeg_data = ws.win.eeg; % Replace 'eeg' with actual field name for EEG data
eeg_timestamps = ws.win.eeg_t;

% Extract EEG labels
eeg_labels = ws.names.eeg; % EEG channel labels

% Define the sampling frequency (replace with the actual sampling frequency)
sampling_frequency = 1000; % Replace with the actual value in Hz

% Create time vector for EEG
eeg_time_vector = eeg_timestamps - eeg_timestamps(1);

% Define the EEG channels you want to select
eeg_channels_to_select = {'C3', 'C4', 'CP1', 'CP2', 'CP5', 'CP6', 'Cz'};

% Define the alpha and beta frequency ranges
alpha_range = [8, 13]; % Alpha frequency range (8-13 Hz)
beta_range = [13, 30]; % Beta frequency range (13-30 Hz)

% Preallocate matrices to store pre-processed data
alpha_bandpass_data = zeros(size(eeg_data));
beta_bandpass_data = zeros(size(eeg_data));

% Loop through selected channel names
for i = 1:length(eeg_channels_to_select)
    channel_name = eeg_channels_to_select{i};
    
    % Find the index of the channel name in eeg_labels
    channel_index = find(strcmp(eeg_labels, channel_name));
    
    if ~isempty(channel_index)
        % Extract EEG data for the selected channel
        channel_data = eeg_data(:, channel_index);
        
        % Apply a bandpass filter for the alpha and beta ranges
        alpha_bandpass = bandpass(channel_data, alpha_range, sampling_frequency);
        beta_bandpass = bandpass(channel_data, beta_range, sampling_frequency);
        
        % Store the filtered data in the pre-allocated matrices
        alpha_bandpass_data(:, channel_index) = alpha_bandpass;
        beta_bandpass_data(:, channel_index) = beta_bandpass;
        
        % Create a new figure for each channel's alpha and beta data
        figure;
        subplot(2, 1, 1);
        plot(eeg_time_vector, alpha_bandpass);
        title(['Alpha Band EEG Channel ' channel_name]);
        xlabel('Time (s)');
        ylabel('Amplitude');
        grid on;
        
        subplot(2, 1, 2);
        plot(eeg_time_vector, beta_bandpass);
        title(['Beta Band EEG Channel ' channel_name]);
        xlabel('Time (s)');
        ylabel('Amplitude');
        grid on;
    else
        % Handle the case where the channel name is not found
        disp(['EEG Channel ' channel_name ' not found']);
    end
end

% Now you have alpha_bandpass_data and beta_bandpass_data matrices
% containing pre-processed EEG data in the alpha and beta frequency bands.
