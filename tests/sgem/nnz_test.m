function test_suite = nnz_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    x = generateMatrices(2, 5, {'A', 'AR', 'AI', 'P', 'PR', 'PI'});
    validateDoubleConsistency(@(x) nnz(x), x);
end
