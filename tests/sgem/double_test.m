function test_suite = double_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    x = generateMatrices(2, 5, {'A', 'AR', 'AI', 'P', 'PR', 'PI'});
    validateDoubleConsistency(@(x) double(x), x);

    y = sparse(rand(5));
    assert(sum(sum(abs(double(gemify(y)) - y))) < 1e-13);
end
