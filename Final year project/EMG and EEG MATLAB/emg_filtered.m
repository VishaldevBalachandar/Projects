
% Define the labels for muscle movements
muscle_labels = ws.names.emg;

% Analog Filtering (Bandpass): Apply analog bandpass filtering to the raw signal before digitizing it.

% Calculate the Nyquist frequency based on the denominator coefficients of the transfer function
den = [1.0000, 5.9519, 6.4455, 1.5103];
nyquist_frequency = 1 / (2 * max(den));

% Define the desired low and high cutoff frequencies in normalized units (0 to 1)
low_cutoff_normalized = 0.02;  % Adjust as needed
high_cutoff_normalized = 0.4;  % Adjust as needed

% Ensure that the high cutoff is within the Nyquist range
if high_cutoff_normalized > nyquist_frequency
    high_cutoff_normalized = nyquist_frequency - 0.01;  % Adjust to be just below Nyquist
end

% Apply Butterworth bandpass filter
[b, a] = butter(4, [low_cutoff_normalized, high_cutoff_normalized], 'bandpass');

% Apply the filter to EMG data
filtered_emg = filtfilt(b, a, emg_data);

% Rectify the signal
rectified_emg = abs(filtered_emg);

% Apply a digital low-pass filter to obtain the "linear envelope" of the signal
% Use a passband frequency within the Nyquist range (e.g., 0.2 * nyquist_frequency)
passband_frequency = 0.2 * nyquist_frequency;
linear_envelope = lowpass(rectified_emg, passband_frequency, nyquist_frequency);

% Get the number of channels
num_channels = size(linear_envelope, 2);

% Create a figure for each filtered channel with muscle labels
for channel_number = 1:num_channels
    % Create a new figure for the current channel
    figure;
    
    % Get the corresponding muscle label from the muscle_labels array
    if channel_number <= length(muscle_labels)
        muscle_label = muscle_labels{channel_number};
    else
        muscle_label = 'Unknown';
    end
    
    % Plot the filtered EMG signal for the current channel
    plot(emg_timestamps, linear_envelope(:, channel_number));
    
    % Add a title and labels to the figure
    title(['Filtered EMG Signal - Muscle: ' muscle_label]);
    xlabel('t [s])');
    ylabel('Amplitude [mV]');
    grid on;
end
