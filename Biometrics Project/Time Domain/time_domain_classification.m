function result = time_domain_classification(filePath, expectedFs, groundTruthLabel)
    % Check if expectedFs is provided, if not, determine it from the file
    if nargin < 2
        info = audioinfo(filePath);
        expectedFs = info.TotalSamples / info.Duration;
    end

    fs = expectedFs;  % Use the determined or provided sampling frequency
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
    
    % Read audio from the file with the correct sampling frequency
    [x, fs_read] = audioread(filePath, 'SamplingRate', fs);

    % Ensure the sampling frequency matches
    if fs_read ~= fs
        warning('Sampling frequency mismatch. Actual: %d, Expected: %d', fs_read, fs);
        % Handle the mismatch as needed
    end
    
    figure;
    % plot(x);
    xlabel("Samples"); ylabel("Normalized Amplitude"); 
    
    % Play the recorded audio
    sound(x, fs_read);
    
    % Silence Detection
    i = 1;
    while i <= length(x) && abs(x(i)) < 0.05  % Detect Speech signal Position
        i = i + 1;
    end
    
    % Check if i exceeds the length of x
    if i > length(x)
        % Handle the case where i exceeds the length of x
        warning('Speech signal not found within the expected range.');
        result = false;  % or handle as needed
        return;
    end
    
    x(1 : i) = [];
    x(6000 : end) = 0;  % Extract Only 2500 samples of Actual Speech

    
    x1 = x;
    figure;
    % plot(x1);
    xlabel("Samples"); ylabel("Normalized Amplitude"); 
    
    % Windowing and processing for 12 short-time windows
    d = zeros(1, 12);
    for k = 1:12
        % Ensure x1 and windows{k} have compatible sizes
        if length(x1) ~= length(windows{k})
            % Adjust the length of x1 or windows{k} to be the same
            min_length = min(length(x1), length(windows{k}));
            x1 = x1(1:min_length);
            windows{k} = windows{k}(1:min_length);
        end
    
        nx = x1 .* windows{k};
        
        % Add a check to ensure the index i does not exceed the length of nx
        i = 1;
        while i <= length(nx) && abs(nx(i)) == 0
            i = i + 1;
        end
        
        % Check if i exceeds the length of nx
        if i > length(nx)
            % Handle the case where i exceeds the length of nx
            warning('Index exceeds the number of array elements. Skipping this window.');
            continue;
        end
        
        nx(1 : i) = [];
        nx(6000 : end) = 0;
        nx(501 : end) = [];
        X = abs(fft(nx));
        [~, d(k)] = max(X);
    end

    % Save the Feature Vector as a .dat file for comparison in the testing phase
    dx = [d(1), d(2), d(3), d(4), d(5), d(6), d(7), d(8), d(9), d(10), d(11), d(12)];
    fid = fopen('feature.dat', 'w');
    fwrite(fid, dx, 'real*8');
    fclose(fid);

    % Retrieve the Feature Vector from the Training Phase
    fid = fopen('feature.dat', 'r');
    dy = fread(fid, 12, 'real*8');
    fclose(fid);
    dy = dy.';

    % Check the deviation between dominant spectral components in each window
    deviation = sum(abs(dy - dx) < 3);

    % Check for the desired number of matches
    if deviation > 3
        fprintf('\n\nACCESS GRANTED\n\n');
        result = true;
    else
        fprintf('\n\nACCESS DENIED\n\n');
        result = false;
    end
end
