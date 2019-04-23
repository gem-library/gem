function test_suite = test_gemSparseLikeMatlab()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_persistent_value
    a = gemSparseLikeMatlab;
    gemSparseLikeMatlab(1);
    assert(gemSparseLikeMatlab == 1);
    gemSparseLikeMatlab(0);
    assert(gemSparseLikeMatlab == 0);
    gemSparseLikeMatlab(a);
    assert(gemSparseLikeMatlab == a);
end

function test_likeMatlab
    a = gemSparseLikeMatlab;
    
    Ms = generateMatrices(10, 10, 'P');
    for M = Ms
        gemSparseLikeMatlab(0);
        assert(~issparse(cos(M{1})));
        gemSparseLikeMatlab(1);
        assert(issparse(cos(M{1})));
    end
    
    gemSparseLikeMatlab(a);
end
