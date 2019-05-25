function test_suite = sgem_rand_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_uniformity
    x = sgem.rand(1000);
    assert(isequal(size(x), [1000 1000]));
    assert(abs(mean(mean(x)) - 1/2) < 0.1);
end

function test_inputs
    assert(isequal(size(sgem.rand), [1 1]));
    assert(isequal(size(sgem.rand(3)), [3 3]));
    assert(isequal(size(sgem.rand([4 5])), [4 5]));
    shouldProduceAnError(@() sgem.rand([1,2,3]));

    assert(isequal(size(sgem.rand(4, 5)), [4 5]));
    shouldProduceAnError(@() sgem.rand([1 2],2));

    shouldProduceAnError(@() sgem.rand(1,2,3));
end
