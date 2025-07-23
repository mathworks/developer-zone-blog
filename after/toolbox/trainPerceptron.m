function [weights, bias] = trainPerceptron(weights, bias, inputs, targets, learning_rate, epochs)
% Train the perceptron using the provided inputs and targets
for epoch = 1:epochs
    for i = 1:size(inputs, 1)
        prediction = calculateWeightedSum(weights, bias, inputs(i, :));
        error = targets(i) - prediction;
        weights = weights + learning_rate * error * inputs(i, :);
        bias = bias + learning_rate * error;
    end
end
end