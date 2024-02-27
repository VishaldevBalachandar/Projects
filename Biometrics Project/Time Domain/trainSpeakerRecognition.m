function trainSpeakerRecognition()
    % Parameters
    fs = 10000;          % Sampling Frequency
    
    % Window Definitions
    w = hamming(2500);    % Hamming window to smoothen speech frame
    h = hamming(256);     % Hamming window to find STFT
    
    % Twelve windows in Time-domain to compute STFT
    windows = cell(1, 12);
    windows{1} = [h ; zeros(2244, 1)];
    windows{2} = [zeros(200, 1) ; h ; zeros(2044, 1)];
    windows{3} = [zeros(400, 1) ; h ; zeros(1844, 1)];
    windows{4} = [zeros(600, 1) ; h ; zeros(1644, 1)];
    windows{5} = [zeros(800, 1) ; h ; zeros(1444, 1)];
    windows{6} = [zeros(1000, 1) ; h ; zeros(1244, 1)];
    windows{7} = [zeros(1200, 1) ; h ; zeros(1044, 1)];
    windows{8} = [zeros(1400, 1) ; h ; zeros(844, 1)];
    windows{9} = [zeros(1600, 1) ; h ; zeros(644, 1)];
    windows{10} = [zeros(1800, 1) ; h ; zeros(444, 1)];
    windows{11} = [zeros(2000, 1) ; h ; zeros(244, 1)];
    windows{12} = [zeros(2244, 1) ; h];
    
    % Display Hamming Windows 1 to 12 (commented out for now)
    % figure;
    % for i = 1:12
    %     subplot(4, 3, i);
    %     plot(windows{i});
    %     title(['Hamming Window ' num2str(i)]);
    %     xlabel('Sample Index');
    %     ylabel('Amplitude');
    % end
    
    % Record Training signal
    recorder = audiorecorder(fs, 16, 1);   % 16 bits, 1 channel
    disp('Hit enter and speak into the microphone');
    pause;
    recordblocking(recorder, 1);           % Record for 1 second
    x = getaudiodata(recorder);

    % Plot the recorded audio
    figure;
    plot(x);
    xlabel("Samples"); ylabel("Normalized Amplitude");
    
    % Play the recorded audio
    sound(x, fs);
    
    % Silence Detection
    i = 1;
    while abs(x(i)) < 0.05  % Detect Speech signal Position
        i = i + 1;
    end
    x(1 : i) = [];
    x(6000 : 10000) = 0;   % Extract Only 2500 samples of Actual Speech
    x(2501 : 10000) = [];
    x1 = x;
    
    % Plot the processed audio
    figure;
    plot(x1);
    xlabel("Samples"); ylabel("Normalized Amplitude");
    
    % Windowing and processing for 12 short-time windows
    d = zeros(1, 12);
    for k = 1:12
        nx = x1 .* windows{k};
        i = 1;
        while abs(nx(i)) == 0
            i = i + 1;
        end
        nx(1 : i) = [];
        nx(6000 : 10000) = 0;
        nx(501 : 10000) = [];
        X = abs(fft(nx));
        [~, d(k)] = max(X);
    end
    
    % Save the Feature Vector as a .dat file for comparison in the testing phase
    fid = fopen('feature.dat', 'w');
    fwrite(fid, d, 'real*8');
    fclose(fid);
    
    % Compute and display the STFT
    figure;
    subplot(2, 1, 2);
    spectrogram(x1, hamming(256), 128, 256, fs, 'yaxis');
    title("Short-Time Fourier Transform (STFT)");
end