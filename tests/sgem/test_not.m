function test_suite = test_not()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    x = generateMatrices(10, 5, {'PR'});
    validateDoubleConsistency(@(x) not(x), x);
end
