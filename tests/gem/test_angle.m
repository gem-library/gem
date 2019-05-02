function test_suite = test_angle()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    x = generateMatrices(2, 5, {'F', 'FR', 'FI', 'P'});
    validateDoubleConsistency(@(x) angle(x), x);
end
