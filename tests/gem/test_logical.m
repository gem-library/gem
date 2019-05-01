function test_suite = test_logical()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    x = generateMatrices(2, 5, {'FR', 'PR'});
    validateDoubleConsistency(@(x) logical(full(x)), x);
end

function test_nan
    try
        logical(gem(nan));
        assert(false);
    catch
    end
end
