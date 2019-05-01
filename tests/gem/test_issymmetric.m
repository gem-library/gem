function test_suite = test_issymmetric()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    x = generateMatrices(2, 5, {'F', 'FR', 'FI', 'FH', 'FHR', 'FHI'});
    validateDoubleConsistency(@(x) issymmetric(x), x);
end

