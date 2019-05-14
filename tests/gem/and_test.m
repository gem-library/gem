function test_suite = and_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    x = generateMatrices(2, 5, {'FR', 'PR'});
    validateDoubleConsistency(@(x) and(full(x), full(x)), x);
    
    % We generate another set of matrices with identical dimensions
    y = generateDoubleMatrices(2, 5, {'FR', 'PR'});    
    validateDoubleConsistency2(@(x,y) and(full(x),full(y)), y(1,:), y(2,:));
end
