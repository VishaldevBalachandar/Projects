% Initialize matrices to store the features
mav_features = zeros(size(alpha_bandpass_data, 1), length(eeg_channels_to_select));
sd_features = zeros(size(alpha_bandpass_data, 1), length(eeg_channels_to_select));
variance_features = zeros(size(alpha_bandpass_data, 1), length(eeg_channels_to_select));

for i = 1:length(eeg_channels_to_select)
    channel_name = eeg_channels_to_select{i};
    
    % Find the index of the channel name in eeg_labels
    channel_index = find(strcmp(eeg_labels, channel_name));
    
    if ~isempty(channel_index)
        % Extract EEG data for the selected channel
        channel_data_alpha = alpha_bandpass_data(:, channel_index);
        channel_data_beta = beta_bandpass_data(:, channel_index);
        
        % Calculate MAV, SD, and V for alpha and beta data
        mav_alpha = mean(abs(channel_data_alpha));
        mav_beta = mean(abs(channel_data_beta));
        
        sd_alpha = std(channel_data_alpha);
        sd_beta = std(channel_data_beta);
        
        variance_alpha = var(channel_data_alpha);
        variance_beta = var(channel_data_beta);
        
        % Store the features
        mav_features(:, i) = mav_alpha;
        sd_features(:, i) = sd_alpha;
        variance_features(:, i) = variance_alpha;
    else
        % Handle the case where the channel name is not found
        disp(['EEG Channel ' channel_name ' not found']);
    end
end
% Define the frequency bands
alpha_frequency_band = [8, 12]; % Alpha frequency band (8-12 Hz)
beta_frequency_band = [12, 30]; % Beta frequency band (12-30 Hz)

% Initialize matrices to store the features
asb_features = zeros(size(alpha_bandpass_data, 1), length(eeg_channels_to_select));
ppsd_features = zeros(size(alpha_bandpass_data, 1), length(eeg_channels_to_select));
fppsd_features = zeros(size(alpha_bandpass_data, 1), length(eeg_channels_to_select));
se_features = zeros(size(alpha_bandpass_data, 1), length(eeg_channels_to_select));

for i = 1:length(eeg_channels_to_select)
    channel_name = eeg_channels_to_select{i};
    
    % Find the index of the channel name in eeg_labels
    channel_index = find(strcmp(eeg_labels, channel_name));
    
    if ~isempty(channel_index)
        % Extract EEG data for the selected channel
        channel_data_alpha = alpha_bandpass_data(:, channel_index);
        channel_data_beta = beta_bandpass_data(:, channel_index);
        
        % Calculate ASB, PPSD, FPPSD, and SE for alpha and beta data
        % You will need to implement Welch's method here
        
    else
        % Handle the case where the channel name is not found
        disp(['EEG Channel ' channel_name ' not found']);
    end
end
% Define the wavelet parameters (e.g., 'db4' wavelet and level 5 decomposition)
wavelet_name = 'db4';
wavelet_level = 5;

% Initialize matrices to store the features
ca_features = cell(length(eeg_channels_to_select), 1);
cd_features = cell(length(eeg_channels_to_select), 1);

for i = 1:length(eeg_channels_to_select)
    channel_name = eeg_channels_to_select{i};
    
    % Find the index of the channel name in eeg_labels
    channel_index = find(strcmp(eeg_labels, channel_name));
    
    if ~isempty(channel_index)
        % Extract EEG data for the selected channel
        channel_data_alpha = alpha_bandpass_data(:, channel_index);
        channel_data_beta = beta_bandpass_data(:, channel_index);
        
        % Perform DWT for alpha and beta data
        [ca_alpha, cd_alpha] = wavedec(channel_data_alpha, wavelet_level, wavelet_name);
        [ca_beta, cd_beta] = wavedec(channel_data_beta, wavelet_level, wavelet_name);
        
        % Store the features
        ca_features{i} = ca_alpha;
        cd_features{i} = cd_alpha;
    else
        % Handle the case where the channel name is not found
        disp(['EEG Channel ' channel_name ' not found']);
    end
end
