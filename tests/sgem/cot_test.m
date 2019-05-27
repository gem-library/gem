function test_suite = cot_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    x = generateMatrices(2, 5, {'A', 'AR', 'AI'});
    validateDoubleConsistency(@(x) cot(x), x, 1e-4);
end

function test_sparseLikeMatlab
    initStatus = gem.sparseLikeMatlab;
    
    gem.sparseLikeMatlab(0);
    assert(isa(cot(sgem(rand)), 'gem'));
    gem.sparseLikeMatlab(1);
    assert(isa(cot(sgem(rand)), 'sgem'));
    
    gem.sparseLikeMatlab(initStatus);
end
