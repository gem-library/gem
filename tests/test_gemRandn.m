function test_suite = test_gemRandn()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_inputs
    assert(isequal(size(gemRandn), [1 1]));
    assert(isequal(size(gemRandn(3)), [3 3]));
    assert(isequal(size(gemRandn([4 5])), [4 5]));
    try
        gemRandn([1,2,3]);
        assert(false);
    catch
    end
    
    assert(isequal(size(gemRandn(4, 5)), [4 5]));
    try
        gemRandn([1 2],2);
        assert(false);
    catch
    end
    
    try
        gemRandn(1,2,3);
        assert(false);
    catch
    end
end
