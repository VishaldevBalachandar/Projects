% Loop through selected channel names
for i = 1:length(selected_channels)
    channel_name = selected_channels{i};
    
    % Find the index of the channel name in eeg_labels
    channel_index = find(strcmp(eeg_labels, channel_name));
    
    if ~isempty(channel_index)
        % Extract EEG data for the selected channel
        channel_data = eeg_data(:, channel_index);
        
        % Parameters for the spectrogram
        window_length = 256; % You can adjust this window size as needed
        overlap_length = window_length / 2; % Overlap between windows
        fs = 1 / (eeg_time_vector(2) - eeg_time_vector(1));  % Sampling frequency
        
        % Create a spectrogram with specified frequency and time ranges
        figure;
        [S, F, T, P] = spectrogram(channel_data, hamming(window_length), overlap_length, [], fs, 'yaxis');
        
        % Set the frequency range from 0 to 100 Hz
        ylim([0 100]);
        
        % Set the time range from 0 to 8 seconds
        xlim([0 8]);
        
        % Customize the color mapping to highlight alpha and beta bands
        colormap jet; % Use the 'jet' colormap for better visibility
        
        % You can adjust the color mapping based on your preference
        % For example, you can set colors for specific frequency ranges:
        % Find the indices corresponding to alpha (8-13 Hz) and beta (13-30 Hz) bands
        alpha_indices = find(F >= 8 & F <= 13);
        beta_indices = find(F > 13 & F <= 30);
        
        % Highlight the alpha and beta bands with different colors
        P_alpha = P(alpha_indices, :);
        P_beta = P(beta_indices, :);
        
        % Plot the spectrogram with custom colors
        imagesc(T, F, 10 * log10(P)); % Use a logarithmic scale for better visualization
        set(gca, 'YDir', 'normal'); % Reverse the Y-axis direction
        
        % Add color bars to indicate intensity for alpha and beta bands
        c = colorbar;
        c.Label.String = 'Power/Frequency (dB/Hz)';
        
        % You can manually set the color axis limits based on your data
        % Adjust these values as needed to highlight the alpha and beta bands
        caxis([min(min(10 * log10(P))) max(max(10 * log10(P)))]);
        
        title(['Spectrogram of EEG Channel ' channel_name]);
        xlabel('Time (s)');
        ylabel('Frequency (Hz)');
        
        % You can further customize the plot as needed
    else
        % Handle the case where the channel name is not found
        disp(['EEG Channel ' channel_name ' not found']);
    end
end
