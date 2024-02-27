classdef SpeakerVerificationApp < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure               matlab.ui.Figure
        TrainButton           matlab.ui.control.Button
        TestButton            matlab.ui.control.Button
        ResultLabel           matlab.ui.control.Label
        TrainingData           double
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: TrainButton
        function TrainButtonPushed(app, event)
            % Record Training signal
            fs = 10000; % Sampling Frequency
            t = hamming(4000); % Hamming window to smooth the speech signal
            w = [t ; zeros(6000,1)];
            f = (1:10000);
            mel(f) = 2595 * log(1 + f / 700); % Linear to Mel frequency scale conversion
            tri = triang(100);
            win1 = [tri ; zeros(9900,1)]; % Defining overlapping triangular windows for

            % Record Training signal
            recorder = audiorecorder(fs, 16, 1); % 16 bits, 1 channel
            disp('Hit enter and speak into the microphone');
            pause;
            recordblocking(recorder, 1); % Record for 1 second
            x = getaudiodata(recorder);

            i = 1;
            while abs(x(i)) < 0.05 % Silence detection
                i = i + 1;
            end
            x(1 : i) = [];
            x(6000 : 10000) = 0;
            x1 = x.* w;

            mx = fft(x1); % Transform to frequency domain
            nx = abs(mx(floor(mel(f)))); % Mel warping
            nx = nx./ max(nx);
            nx1 = nx.* win1;
            sx1 = sum(nx1.^ 2); % Determine the energy of the signal within each window
            sx = log(sx1);
            dx = dct(sx); % Determine DCT of Log of the spectrum energies

            fid = fopen('sample.dat', 'w');
            fwrite(fid, dx, 'real*8'); % Store this feature vector as a .dat file
            fclose(fid);

            app.TrainingData = dx;
            app.ResultLabel.Text = 'Training completed.';
        end

        % Button pushed function: TestButton
        function TestButtonPushed(app, event)
            % Record Testing signal
            fs = 10000; % Sampling Frequency
            t = hamming(4000); % Hamming window to smooth the speech signal
            w = [t ; zeros(6000,1)];
            f = (1:10000);
            mel(f) = 2595 * log(1 + f / 700); % Linear to Mel frequency scale conversion
            tri = triang(100);
            win1 = [tri ; zeros(9900,1)]; % Defining overlapping triangular windows for

            % Record Testing signal
            recorder = audiorecorder(fs, 16, 1); % 16 bits, 1 channel
            disp('Hit enter and speak into the microphone');
            pause;
            recordblocking(recorder, 1); % Record for 1 second
            y = getaudiodata(recorder);

            i = 1;
            while abs(y(i)) < 0.05 % Silence detection
                i = i + 1;
            end
            y(1 : i) = [];
            y(6000 : 10000) = 0;
            y1 = y.* w;

            my = fft(y1); % Transform to frequency domain
            ny = abs(my(floor(mel(f)))); % Mel warping
            ny = ny./ max(ny);
            ny1 = ny.* win1;
            sy1 = sum(ny1.^ 2); % Determine the energy of the signal within each window
            sy = log(sy1);
            dy = dct(sy); % Determine DCT of Log of the spectrum energies

            % Compare with Training Data
            MSE = sum((app.TrainingData - dy).^2) / length(dy);

            if MSE < 1
                app.ResultLabel.Text = 'ACCESS GRANTED';
            else
                app.ResultLabel.Text = 'ACCESS DENIED';
            end
        end
    end

    % App initialization and construction
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)
            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100, 100, 320, 240];
            app.UIFigure.Name = 'Speaker Verification App';
            app.UIFigure.CloseRequestFcn = createCallbackFcn(app, @closeApp, true);

            % Create TrainButton
            app.TrainButton = uibutton(app.UIFigure, 'push');
            app.TrainButton.ButtonPushedFcn = createCallbackFcn(app, @TrainButtonPushed, true);
            app.TrainButton.Position = [65, 143, 100, 22];
            app.TrainButton.Text = 'Train';

            % Create TestButton
            app.TestButton = uibutton(app.UIFigure, 'push');
            app.TestButton.ButtonPushedFcn = createCallbackFcn(app, @TestButtonPushed, true);
            app.TestButton.Position = [189, 143, 100, 22];
            app.TestButton.Text = 'Test';

            % Create ResultLabel
            app.ResultLabel = uilabel(app.UIFigure);
            app.ResultLabel.Position = [65, 87, 200, 22];
            app.ResultLabel.Text = '';
            app.ResultLabel.HorizontalAlignment = 'center';


            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = SpeakerVerificationApp
            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startup)
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end

    % Code that executes before app deletion
    methods (Access = private)

        % Close figure function: closeApp
        function closeApp(app, event)
            % Delete the app when the figure is closed
            delete(app);
        end

        % Startup function: startup
        function startup(app)
            % Initialize the app properties
            app.TrainingData = [];
        end
    end
end
