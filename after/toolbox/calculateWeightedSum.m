function output = calculateWeightedSum(weights, bias, inputs)
% Compute the weighted sum
total_input = sum(weights .* inputs) + bias;

% Activation logic
if total_input > 0 % step function threshold; activate if weighted sum is positive
    output = 1;
else
    output = 0;
end
end