classdef PerceptronTrainingTest < matlab.unittest.TestCase

    methods (Test)
        function testANDPerceptron(testCase)
            inputs = [0, 0; 0, 1; 1, 0; 1, 1];
            targets = [0, 0, 0, 1]; % AND gate targets
            [weights, bias] = initializeWeights(2);

            learning_rate = 0.1;
            epochs = 100;

            [trained_weights, bias] = trainPerceptron(weights, bias, inputs, targets, learning_rate, epochs);
            predictions = predict(trained_weights, bias, inputs);

            testCase.verifyEqual(predictions, targets, "Training did not converge to correct outputs.");
        end
    end
end