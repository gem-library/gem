function test_suite = xor_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    x = generateMatrices(2, 5, {'PR'});
    validateDoubleConsistency(@(x) xor(x, x), x);
    
    % We generate another set of matrices with identical dimensions
    y = generateDoubleMatrices(2, 5, {'PR'});
    validateDoubleConsistency2(@(x,y) xor(x,y), y(1,:), y(2,:));
end
