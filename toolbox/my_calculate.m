function out = my_calculate(in1, in2, operation)

switch operation
    case "add"
        out = my_add(in1, in2);
    case "subtract"
        out = my_subtract(in1, in2);
    case "multiply"
        out = my_multiply(in1, in2);
    case "divide"
        out = my_divide(in1, in2);
    otherwise
        error("MATLAB:InvalidOp", "Invalid operation");
end

end
