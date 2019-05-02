function test_suite = test_nnz()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    x = generateMatrices(2, 5, {'F', 'FR', 'FI', 'P', 'PR', 'PI'});
    validateDoubleConsistency(@(x) nnz(full(x)), x);
end
