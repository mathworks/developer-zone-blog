function predictions = predict(weights, inputs)
% Predict outputs for a set of inputs
predictions = arrayfun(@(i) calculateWeightedSum(weights, inputs(i, :)), 1:size(inputs, 1));
end