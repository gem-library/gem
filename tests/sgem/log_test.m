function test_suite = log_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    x = generateMatrices(2, 5, {'A', 'AR', 'AI'});
    validateDoubleConsistency(@(x) log(x), x, 1e-9);
end

function test_sparseLikeMatlab
    initStatus = gem.sparseLikeMatlab;
    
    gem.sparseLikeMatlab(0);
    assert(isa(log(sgem(rand)), 'gem'));
    gem.sparseLikeMatlab(1);
    assert(isa(log(sgem(rand)), 'sgem'));
    
    gem.sparseLikeMatlab(initStatus);
end
