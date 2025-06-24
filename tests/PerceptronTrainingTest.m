classdef PerceptronTrainingTest < matlab.unittest.TestCase

    methods (Test)
        function testANDPerceptron(testCase)
            inputs = [0, 0; 0, 1; 1, 0; 1, 1];
            targets = [0, 0, 0, 1]; % AND gate targets
            weights = initializeWeights();

            learning_rate = 0.1;
            epochs = 100;

            trained_weights = trainPerceptron(weights, inputs, targets, learning_rate, epochs);
            predictions = predict(trained_weights, inputs);

            testCase.verifyEqual(predictions, targets, "Training did not converge to correct outputs.");
        end
    end
end
