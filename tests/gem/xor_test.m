function test_suite = xor_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    x = generateMatrices(2, 5, {'FR', 'PR'});
    validateDoubleConsistency(@(x) xor(full(x), full(x)), x);
    
    % We generate another set of matrices with identical dimensions
    y = generateMatrices(2, 5, {'FR', 'PR'}, 2);
    validateDoubleConsistency2(@(x,y) xor(full(x),full(y)), y(1,:), y(2,:));
end
