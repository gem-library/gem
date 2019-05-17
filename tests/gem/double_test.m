function test_suite = double_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    x = generateMatrices(2, 5, {'F', 'FR', 'FI'});
    validateDoubleConsistency(@(x) double(x), x);
    
    y = rand(5);
    assert(sum(sum(abs(double(gem(y)) - y))) < 1e-13);
end
