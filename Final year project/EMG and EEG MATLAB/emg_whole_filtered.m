% Extract relevant data from the loaded file
emg_data = ws.win.emg;          % EMG data
emg_timestamps = ws.win.emg_t;  % Timestamps for EMG data

% Extract relevant data from the P file
lift_events = P.AllLifts;  % Lift events data
event_timestamps = lift_events(:, 12:23);  % Timestamps for lift events

% Define the labels for muscle movements
muscle_labels = ws.names.emg;

% Analog Filtering (Bandpass): Apply analog bandpass filtering to the raw signal before digitizing it.
% This filter should typically have a low-frequency cutoff of 5 to 20 Hz and a high-frequency cutoff of 200 Hz to 1 kHz.

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

% Now you can plot the filtered signals or proceed with feature extraction
% Plot the filtered signal (linear envelope) with muscle labels
figure(2);
for channel_number = 1:size(linear_envelope, 2)
    muscle_label = muscle_labels{channel_number};
    plot(emg_timestamps, linear_envelope(:, channel_number), 'DisplayName', muscle_label);
    hold on;
end
title('Filtered Signal (Linear Envelope) with Muscle Labels');
xlabel('Time (s)');
ylabel('Amplitude');
legend('Location', 'Best');
hold off;

