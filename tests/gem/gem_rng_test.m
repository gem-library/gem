function test_suite = gem_rng_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_seed
    seed = gem.rand*1e10;
    
    gem.rng(seed);
    x1 = gem.rand(1,10);

    gem.rng(seed);
    x2 = gem.rand(1,10);
    assert(isequal(x1, x2));
    
    gem.rng;
    x3 = gem.rand(1,10);
    assert(~isequal(x1, x3));

    gem.rng(seed);
    x4 = gem.rand(1,10);
    assert(isequal(x1, x4));

    gem.rng;
    x5 = gem.rand(1,10);
    assert(~isequal(x3, x5));
end

function test_inputs
    shouldProduceAnError(@() gem.rng([2 3]));
end

