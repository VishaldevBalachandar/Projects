function TestButtonPushed(app, event)
    fs = 10000; % Sampling Frequency
    t = hamming(4000); % Hamming window to smooth the speech signal
    w = [t; zeros(6000, 1)];
    f = (1:10000);
    mel = 2595 * log10(1 + f / 700); % Corrected Mel frequency scale conversion
    tri = triang(100);
    win1 = [tri; zeros(9900, 1)]; % Defining overlapping triangular windows for
    win2 = [zeros(50, 1); tri; zeros(9850, 1)]; % frequency domain analysis
    win3 = [zeros(100, 1); tri; zeros(9800, 1)];
    win4 = [zeros(150, 1); tri; zeros(9750, 1)];
    win5 = [zeros(200, 1); tri; zeros(9700, 1)];
    win6 = [zeros(250, 1); tri; zeros(9650, 1)];
    win7 = [zeros(300, 1); tri; zeros(9600, 1)];
    win8 = [zeros(350, 1); tri; zeros(9550, 1)];
    win9 = [zeros(400, 1); tri; zeros(9500, 1)];
    win10 = [zeros(450, 1); tri; zeros(9450, 1)];
    win11 = [zeros(500, 1); tri; zeros(9400, 1)];
    win12 = [zeros(550, 1); tri; zeros(9350, 1)];
    win13 = [zeros(600, 1); tri; zeros(9300, 1)];
    win14 = [zeros(650, 1); tri; zeros(9250, 1)];
    win15 = [zeros(700, 1); tri; zeros(9200, 1)];
    win16 = [zeros(750, 1); tri; zeros(9150, 1)];
    win17 = [zeros(800, 1); tri; zeros(9100, 1)];
    win18 = [zeros(850, 1); tri; zeros(9050, 1)];
    win19 = [zeros(900, 1); tri; zeros(9000, 1)];
    win20 = [zeros(950, 1); tri; zeros(8950, 1)];

    % Read the audio file
    audioFilePath = '/Users/siddharth/Downloads/speech_commands_v0.02/no/0a2b400e_nohash_2.wav';
    [y, fs] = audioread(audioFilePath);

    % Plot the word
    figure;
    plot(1:length(y), y);
    title('Word - HELLO');
    xlabel('Samples');
    ylabel('Normalized Amplitude');

    % Play the recorded audio
    sound(y, fs);

    % Silence detection
    i = 1;
    while abs(y(i)) < 0.05
        i = i + 1;
    end
    y(1 : i) = [];

    % Plot the word after silence detection
    figure;
    plot(1:length(y), y);
    title('After Silence Detection');
    xlabel('Samples');
    ylabel('Normalized Amplitude');

    % Play the utterance part of the audio
    sound(y, fs);

    w = hamming(length(y));  % Adjust the length of the Hamming window to match the length of y
    y1 = y .* w;

    % Plot the word after using a Hamming window
    figure;
    plot(1:length(y1), y1);
    title('After Using Hamming Window');
    xlabel('Samples');
    ylabel('Normalized Amplitude');

    % Play the utterance part of the audio
    sound(y1, fs);

    my = fft(y1); % Transform to frequency domain

    % Mel-warping
    ny1 = filterBank(mel, abs(my));

    % Plot the Mel-warped signal
    figure;
    plot(1:length(ny1), ny1);
    title('Mel-Warped Signal');
    xlabel('Samples');
    ylabel('Amplitude');

    % Function to apply Mel filter bank
    function output = filterBank(mel, signal)
        output = zeros(1, length(mel)-1);
        for i = 1:length(mel)-1
            startIdx = floor(mel(i));
            endIdx = ceil(mel(i+1));
            output(i) = sum(signal(startIdx:endIdx));
        end
    end
end
