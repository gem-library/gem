function test_suite = ishermitian_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    x = generateMatrices(2, 5, {'F', 'FR', 'FI', 'FH', 'FHR', 'FHI'});
    validateDoubleConsistency(@(x) ishermitian(x), x);
end
