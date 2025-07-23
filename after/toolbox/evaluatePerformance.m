function accuracy = evaluatePerformance(predictions, targets)
% Calculate the accuracy of predictions
correct_predictions = sum(predictions == targets);
accuracy = correct_predictions / length(targets);
end