classdef PerceptionOutputTest < matlab.unittest.TestCase

    methods (Test)
        function testWeightedSum(testCase)
            weights = [0.5, 0.5, -0.7]; % Sample weights
            inputs = [0, 0; 0, 1; 1, 0; 1, 1];
            expected_outputs = [0, 0, 0, 1]; % AND gate expected outputs

            for i = 1:size(inputs, 1)
                output = calculateWeightedSum(weights, inputs(i, :));
                testCase.assertEqual(output, expected_outputs(i), sprintf("Perceptron output unexpected for %d", i));
            end
        end
    end
end