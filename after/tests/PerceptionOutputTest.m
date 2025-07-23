classdef PerceptionOutputTest < matlab.unittest.TestCase

    methods (Test)
        function testWeightedSum(testCase)
            weights = [1 1]; % Sample weights
            bias = -1.5; % Sample bias
            inputs = [0, 0; 0, 1; 1, 0; 1, 1];
            expected_outputs = [0, 0, 0, 1]; % AND gate expected outputs

            for i = 1:size(inputs, 1)
                output = calculateWeightedSum(weights, bias, inputs(i, :));
                testCase.assertEqual(output, expected_outputs(i), sprintf("Perceptron output unexpected for %d", i));
            end
        end
    end
end