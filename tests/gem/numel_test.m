function test_suite = numel_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    x = generateMatrices(2, 5, {'F', 'FR', 'FI'});
    validateDoubleConsistency(@(x) numel(x), x);
end
