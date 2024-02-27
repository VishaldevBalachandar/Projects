classdef SpeakerRecognitionGUI < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure       matlab.ui.Figure
        TrainButton    matlab.ui.control.Button
        TestButton     matlab.ui.control.Button
        ResultLabel    matlab.ui.control.Label
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: TrainButton
        function TrainButtonPushed(app, ~)
            % Call the trainSpeakerRecognition function
            trainSpeakerRecognition();
            app.ResultLabel.Text = 'Training completed.';
        end

        % Button pushed function: TestButton
        function TestButtonPushed(app, ~)
            % Call the testSpeakerRecognition function
            result = testSpeakerRecognition(app);
            
            % Display result
            if result
                app.ResultLabel.Text = 'ACCESS GRANTED';
            else
                app.ResultLabel.Text = 'ACCESS DENIED';
            end
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = SpeakerRecognitionGUI
            % Create UIFigure and components
            app.UIFigure = uifigure('Name', 'Speaker Recognition GUI');
            app.TrainButton = uibutton(app.UIFigure, 'push', 'Text', 'Train', 'Position', [50, 200, 100, 22], 'ButtonPushedFcn', @(src, event) TrainButtonPushed(app, event));
            app.TestButton = uibutton(app.UIFigure, 'push', 'Text', 'Test', 'Position', [200, 200, 100, 22], 'ButtonPushedFcn', @(src, event) TestButtonPushed(app, event));
            app.ResultLabel = uilabel(app.UIFigure, 'Position', [50, 150, 250, 22], 'Text', '');
            
            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end
end
