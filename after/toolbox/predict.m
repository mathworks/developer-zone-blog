function predictions = predict(weights, bias, inputs)
% Predict outputs for a set of inputs
predictions = arrayfun(@(i) calculateWeightedSum(weights, bias, inputs(i, :)), 1:size(inputs, 1));
end