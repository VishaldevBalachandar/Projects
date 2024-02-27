% Initialize matrices to store the MAS features
mas_features = zeros(size(linear_envelope, 1), length(muscle_labels));

window_size = 0.2;  % Set the window size in seconds
overlap = 0.15;     % Set the overlap in seconds

% Calculate the number of samples per window and overlap
window_length = round(window_size * fs);
overlap_length = round(overlap * fs);

for i = 1:length(muscle_labels)
    muscle_name = muscle_labels{i};
    
    % Extract EMG data for the selected muscle
    muscle_data = linear_envelope(:, i);
    
    % Calculate MAS for the muscle data (remove or pad to match sizes)
    mas = abs(diff(muscle_data));
    
    % Initialize start and end indices for the sliding window
    start_idx = 1;
    end_idx = window_length;
    
    % Initialize an index for storing features
    feature_idx = 1;
    
    while end_idx <= length(mas)
        % Calculate MAS for the current window
        mas_window = mas(start_idx:end_idx);
        
        % Ensure the size of mas_window matches mas_features
        if length(mas_window) < size(mas_features, 1)
            % Pad mas_window with zeros to match the size
            mas_window = [mas_window; zeros(size(mas_features, 1) - length(mas_window), 1)];
        elseif length(mas_window) > size(mas_features, 1)
            % Remove the last samples from mas_window to match the size
            mas_window = mas_window(1:size(mas_features, 1));
        end
        
        % Store the MAS feature for this window
        mas_features(:, feature_idx, i) = mas_window;
        
        % Update indices for the next window
        start_idx = start_idx + window_length - overlap_length;
        end_idx = end_idx + window_length - overlap_length;
        
        % Increment the feature index
        feature_idx = feature_idx + 1;
    end
end

% Initialize matrices to store the WL features
wl_features = zeros(size(linear_envelope, 1), length(muscle_labels));

for i = 1:length(muscle_labels)
    muscle_name = muscle_labels{i};
    
    % Extract EMG data for the selected muscle
    muscle_data = linear_envelope(:, i);
    
    % Initialize start and end indices for the sliding window
    start_idx = 1;
    end_idx = window_length;
    
    % Initialize an index for storing features
    feature_idx = 1;
    
    while end_idx <= length(muscle_data)
        % Calculate WL for the current window
        wl_window = sum(abs(diff(muscle_data(start_idx:end_idx))));
        
        % Store the WL feature for this window
        wl_features(:, feature_idx, i) = wl_window;
        
        % Update indices for the next window
        start_idx = start_idx + window_length - overlap_length;
        end_idx = end_idx + window_length - overlap_length;
        
        % Increment the feature index
        feature_idx = feature_idx + 1;
    end
end

% Initialize matrices to store the WA features
wa_features = zeros(size(linear_envelope, 1), length(muscle_labels));

for i = 1:length(muscle_labels)
    muscle_name = muscle_labels{i};
    
    % Extract EMG data for the selected muscle
    muscle_data = linear_envelope(:, i);
    
    % Define the threshold for Willison Amplitude
    threshold = 0.2; % Adjust as needed
    
    % Initialize start and end indices for the sliding window
    start_idx = 1;
    end_idx = window_length;
    
    % Initialize an index for storing features
    feature_idx = 1;
    
    while end_idx <= length(muscle_data)
        % Calculate WA for the current window
        wa_window = sum(abs(diff(muscle_data(start_idx:end_idx)) > threshold));
        
        % Store the WA feature for this window
        wa_features(:, feature_idx, i) = wa_window;
        
        % Update indices for the next window
        start_idx = start_idx + window_length - overlap_length;
        end_idx = end_idx + window_length - overlap_length;
        
        % Increment the feature index
        feature_idx = feature_idx + 1;
    end
end


% Combine the features into a single matrix
features = [mas_features, wl_features, wa_features];

% Save the features for later use
save('emg_features.mat', 'features');

% The code for extracting EMG features with the specified sliding window and overlap is now complete.

