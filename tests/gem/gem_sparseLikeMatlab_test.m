function test_suite = gem_sparseLikeMatlab_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_persistent_value
    a = gem.sparseLikeMatlab;

    gem.sparseLikeMatlab(1);
    assert(gem.sparseLikeMatlab == 1);

    gem.sparseLikeMatlab(0);
    assert(gem.sparseLikeMatlab == 0);

    gem.sparseLikeMatlab(a);
    assert(gem.sparseLikeMatlab == a);
end

function test_likeMatlab
    a = gem.sparseLikeMatlab;
    
    Ms = generateMatrices(10, 10, 'P');
    for M = Ms
        gem.sparseLikeMatlab(0);
        assert(~issparse(cos(M{1})));
        
        gem.sparseLikeMatlab(1);
        assert(issparse(cos(M{1})));
    end
    
    gem.sparseLikeMatlab(a);
end
