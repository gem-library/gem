function test_suite = not_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    x = generateMatrices(10, 5, {'FR', 'PR'});
    validateDoubleConsistency(@(x) not(full(x)), x);
end
