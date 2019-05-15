function test_suite = sign_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    x = generateMatrices(2, 5, {'F', 'FR', 'FI', 'A'});
    validateDoubleConsistency(@(x) sign(full(x)), x);
end
