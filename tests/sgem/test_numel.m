function test_suite = test_numel()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    x = generateMatrices(2, 5, {'A', 'AR', 'AI', 'P', 'PR', 'PI'});
    validateDoubleConsistency(@(x) numel(x), x);
end
