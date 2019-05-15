function test_suite = rank_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    x = generateMatrices(2, 15, {'F', 'FR', 'FI', 'P', 'PR', 'PI'});
    validateDoubleConsistency(@(x) rank(full(x)), x);
end
