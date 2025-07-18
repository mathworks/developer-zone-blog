classdef InitializeWeightsTest < matlab.unittest.TestCase

    methods (Test)
        function testInitialWeights(testCase)
            weights = initializeWeights();
            testCase.assertLength(weights, 3);
        end
    end
end