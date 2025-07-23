function [weights, bias] = initializeWeights(numInputs)
% Initialize weights and bias randomly
weights = rand(1, numInputs);  % Random weights for each input
bias = rand() - 0.5;  % Bias initialized to a small random value between -0.5 and 0.5
end
