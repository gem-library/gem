function test_suite = log10_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    x = generateMatrices(2, 5, {'A', 'AR', 'AI'});
    validateDoubleConsistency(@(x) log10(x), x, 1e-9);
end

function test_sparseLikeMatlab
    initStatus = gemSparseLikeMatlab;
    
    gemSparseLikeMatlab(0);
    assert(isa(log10(sgem(rand)), 'gem'));
    gemSparseLikeMatlab(1);
    assert(isa(log10(sgem(rand)), 'sgem'));
    
    gemSparseLikeMatlab(initStatus);
end
