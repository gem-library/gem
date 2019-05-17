function test_suite = end_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    x = generateMatrices(2, 5, {'F', 'FR', 'FI'});
    validateDoubleConsistency(@(x) x(end), x);
    validateDoubleConsistency(@(x) x(1,end), x);    
    validateDoubleConsistency(@(x) x(end,1), x);    
end

function test_inputs
    x = gemRand(2,3);
    try
        x(1,1,end);
        assert(false);
    catch
    end
end
