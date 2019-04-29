function test_suite = test_all()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    x = generateMatrices(10, 5, {'P', 'PR', 'PI'});
    validateDoubleConsistency(@(x) all(x), x);
end
