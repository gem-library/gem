function test_suite = nonzeros_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    x = generateMatrices(2, 5, {'F', 'FR', 'FI'});
    x = cat(2, x, {gem.rand(1,4)});
    validateDoubleConsistency(@(x) nonzeros(x), x);
end
