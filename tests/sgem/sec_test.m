function test_suite = sec_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    x = generateMatrices(2, 5, {'A', 'AR', 'AI'});
    validateDoubleConsistency(@(x) sec(x), x, 1e-4);
end

function test_sparseLikeMatlab
    initStatus = gem.sparseLikeMatlab;
    
    gem.sparseLikeMatlab(0);
    assert(isa(sec(sgem(rand)), 'gem'));
    gem.sparseLikeMatlab(1);
    assert(isa(sec(sgem(rand)), 'sgem'));
    
    gem.sparseLikeMatlab(initStatus);
end
