function test_suite = or_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    x = generateMatrices(2, 5, {'FR', 'PR'});
    validateDoubleConsistency(@(x) or(full(x), full(x)), x);
    
    % We generate another set of matrices with identical dimensions
    y = generateDoubleMatrices(2, 5, {'FR', 'PR'});
    validateDoubleConsistency2(@(x,y) or(full(x),full(y)), y(1,:), y(2,:));
end
