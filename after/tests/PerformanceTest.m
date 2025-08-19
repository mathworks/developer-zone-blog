classdef PerformanceTest < matlab.unittest.TestCase

    methods (Test)
        function testOne(testCase)
            predictions = [0, 0, 0, 1];
            targets = [0, 0, 0, 1]; % AND gate targets

            accuracy = evaluatePerformance(predictions, targets);
            testCase.verifyEqual(accuracy, 1, "Expected 100% accuracy.");
        end
    end
end