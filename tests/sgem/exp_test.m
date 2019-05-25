function test_suite = exp_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    x = generateMatrices(2, 5, {'A', 'AR', 'AI'});
    validateDoubleConsistency(@(x) exp(x), x, 1e-9);
end

function test_sparseLikeMatlab
    initStatus = gem.sparseLikeMatlab;
    
    gem.sparseLikeMatlab(0);
    assert(isa(exp(sgem(rand)), 'gem'));
    gem.sparseLikeMatlab(1);
    assert(isa(exp(sgem(rand)), 'sgem'));
    
    gem.sparseLikeMatlab(initStatus);
end
