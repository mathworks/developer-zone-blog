classdef PredictionTest < matlab.unittest.TestCase

    methods (Test)
        function testPrediction(testCase)
            inputs = [0, 0; 0, 1; 1, 0; 1, 1];
            targets = [0, 0, 0, 1]; % AND gate targets
            weights = [0.5, 0.5, -0.7]; % Assume these are trained weights

            predictions = predict(weights, inputs);
            testCase.verifyEqual(predictions, targets, "Predictions do not match expected outputs.");
        end    
    end
end

