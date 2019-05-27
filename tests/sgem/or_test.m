function test_suite = or_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    x = generateMatrices(2, 5, {'PR'});
    validateDoubleConsistency(@(x) or(x, x), x);
    
    % We generate another set of matrices with identical dimensions
    y = generateMatrices(2, 5, {'PR'}, 2);
    validateDoubleConsistency2(@(x,y) or(x,y), y(1,:), y(2,:));
end
