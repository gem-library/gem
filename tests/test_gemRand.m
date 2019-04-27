function test_suite = test_gemRand()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_uniformity
    x = gemRand(1000);
    assert(isequal(size(x), [1000 1000]));
    assert(abs(mean(mean(x)) - 1/2) < 0.1);
end

function test_inputs
    assert(isequal(size(gemRandn), [1 1]));
    assert(isequal(size(gemRand(3)), [3 3]));
    assert(isequal(size(gemRand([4 5])), [4 5]));
    try
        gemRand([1,2,3]);
        assert(false);
    catch
    end
    
    assert(isequal(size(gemRand(4, 5)), [4 5]));
    try
        gemRand([1 2],2);
        assert(false);
    catch
    end
    
    try
        gemRand(1,2,3);
        assert(false);
    catch
    end
end
