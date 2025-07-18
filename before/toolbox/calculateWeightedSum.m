function output = calculateWeightedSum(weights, inputs)
% Compute the weighted sum
total_input = sum(weights .* [inputs, 1]);

% Activation logic
if total_input > 0 % step function threshold; activate if weighted sum is positive
    output = 1;
else
    output = 0;
end
end