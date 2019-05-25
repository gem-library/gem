function test_suite = sgem_rng_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_seed
    seed = sgem.rand*1e10;
    
    sgem.rng(seed);
    x1 = sgem.rand(1,10);

    sgem.rng(seed);
    x2 = sgem.rand(1,10);
    assert(isequal(x1, x2));
    
    sgem.rng;
    x3 = sgem.rand(1,10);
    assert(~isequal(x1, x3));

    sgem.rng(seed);
    x4 = sgem.rand(1,10);
    assert(isequal(x1, x4));

    sgem.rng;
    x5 = sgem.rand(1,10);
    assert(~isequal(x3, x5));
end

function test_inputs
    shouldProduceAnError(@() sgem.rng([2 3]));
end

