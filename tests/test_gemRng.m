function test_suite = test_gemRng()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_seed
    seed = gemRand*1e10;
    gemRng(seed);
    x1 = gemRand(1,10);
    gemRng(seed);
    x2 = gemRand(1,10);
    assert(isequal(x1, x2));
end
