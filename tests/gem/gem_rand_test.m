function test_suite = gem_rand_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_uniformity
    x = gem.rand(1000);
    assert(isequal(size(x), [1000 1000]));
    assert(abs(mean(mean(x)) - 1/2) < 0.1);
end

function test_inputs
    assert(isequal(size(gem.rand), [1 1]));
    assert(isequal(size(gem.rand(3)), [3 3]));
    assert(isequal(size(gem.rand([4 5])), [4 5]));
    shouldProduceAnError(@() gem.rand([1,2,3]));

    assert(isequal(size(gem.rand(4, 5)), [4 5]));
    shouldProduceAnError(@() gem.rand([1 2],2));

    shouldProduceAnError(@() gem.rand(1,2,3));
end
