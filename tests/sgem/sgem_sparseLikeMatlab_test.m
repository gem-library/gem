function test_suite = sgem_sparseLikeMatlab_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_persistent_value
    a = sgem.sparseLikeMatlab;

    sgem.sparseLikeMatlab(1);
    assert(sgem.sparseLikeMatlab == 1);

    sgem.sparseLikeMatlab(0);
    assert(sgem.sparseLikeMatlab == 0);

    sgem.sparseLikeMatlab(a);
    assert(sgem.sparseLikeMatlab == a);
end

function test_likeMatlab
    a = sgem.sparseLikeMatlab;
    
    Ms = generateMatrices(10, 10, 'P');
    for M = Ms
        gem.sparseLikeMatlab(0);
        assert(~issparse(cos(M{1})));
        
        gem.sparseLikeMatlab(1);
        assert(issparse(cos(M{1})));
    end
    
    sgem.sparseLikeMatlab(a);
end
