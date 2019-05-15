function test_suite = fix_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    x = generateMatrices(2, 5, {'F', 'FR', 'FI'});
    validateDoubleConsistency(@(x) fix(x), x);
end
