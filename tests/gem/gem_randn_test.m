function test_suite = gem_randn_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_inputs
    assert(isequal(size(gem.randn), [1 1]));
    assert(isequal(size(gem.randn(3)), [3 3]));
    assert(isequal(size(gem.randn([4 5])), [4 5]));
    shouldProduceAnError(@() gem.randn([1,2,3]));
    
    assert(isequal(size(gem.randn(4, 5)), [4 5]));
    shouldProduceAnError(@() gem.randn([1 2],2));
    
    shouldProduceAnError(@() gem.randn(1,2,3));
end
