function test_suite = test_logical()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    x = generateMatrices(2, 5, {'PR'});
    validateDoubleConsistency(@(x) logical(x), x);
end

function test_nan
    try
        logical(sgem(nan));
        assert(false);
    catch
    end
end
