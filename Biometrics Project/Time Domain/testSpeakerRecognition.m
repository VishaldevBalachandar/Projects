function result = testSpeakerRecognition(audioFilePath)
    fs = 10000;  % Sampling Frequency
    h = hamming(256);  % Hamming window to find STFT

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
    
    % Read the audio file
    [x, fs] = audioread(audioFilePath);

    % Normalize the amplitude of the audio
    x = normalize(x);

    % Plot the input speech
    figure;
    plot(1:length(x), x);
    title('Input Speech - HELLO');
    xlabel('Samples');
    ylabel('Normalized Amplitude');

    % Play the entire audio
    sound(x, fs);

    % Silence Detection
    i = 1;
    while abs(x(i)) < 0.05  % Detect Speech signal Position
        i = i + 1;
    end
    x(1 : i) = [];
    
    % Plot the part after silence detection
    figure;
    plot(1:length(x), x);
    title('After Silence Detection');
    xlabel('Samples');
    ylabel('Normalized Amplitude');

    % Play the utterance part of the audio
    sound(x, fs);

    % Windowing and processing for one of the short-time windows
    windowIndex = 6;  % You can change this index as needed
    figure;
    minLen = min(length(x), length(windows{windowIndex}));
    nx = x(1:minLen) .* windows{windowIndex}(1:minLen);
    plot(1:length(nx), nx);
    title(['Windowed Signal - Window ' num2str(windowIndex)]);
    xlabel('Samples');
    ylabel('Amplitude');

    % Plot the frequency spectrum with dominant frequency
    figure;
    X = abs(fft(nx));
    freq = (0:length(X)-1) * fs / length(X);
    plot(freq, 20*log10(X));
    title('Frequency Spectrum');
    xlabel('Frequency (Hz)');
    ylabel('Magnitude (dB)');
    hold on;
    
    % Find the dominant frequency
    [~, d] = max(X);
    line([freq(d), freq(d)], ylim, 'Color', 'red', 'LineStyle', '--');
    
    hold off;

    % Save the Feature Vector as a .dat file for comparison in the testing phase
    dx = X;
    fid = fopen('feature.dat', 'w');
    fwrite(fid, dx, 'real*8');
    fclose(fid);

    % Retrieve the Feature Vector from the Training Phase
    fid = fopen('feature.dat', 'r');
    dy = fread(fid, length(X), 'real*8');
    fclose(fid);
    dy = dy.';

    % Check the deviation between dominant spectral components in each window
    deviation = sum(abs(dy - dx) < 3);

    % Check for the desired number of matches
    if deviation > 5
        fprintf('\n\nACCESS GRANTED\n\n');
        result = true;
    else
        fprintf('\n\nACCESS DENIED\n\n');
        result = false;
    end
end
