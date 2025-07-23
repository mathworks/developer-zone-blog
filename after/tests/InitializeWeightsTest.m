classdef InitializeWeightsTest < matlab.unittest.TestCase

    methods (Test)
        function testInitialWeights(testCase)
            weights = initializeWeights(2);
            testCase.assertLength(weights, 2);
        end
    end
end