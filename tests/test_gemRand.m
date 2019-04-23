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

