function test_suite = sqrt_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    x = generateMatrices(2, 5, {'A', 'AR', 'AI'});
    validateDoubleConsistency(@(x) sqrt(x), x);
end

function test_empty
    assert(isempty(sqrt(sgem([]))));
end
