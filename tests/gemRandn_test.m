function test_suite = gemRandn_test()
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
    shouldProduceAnError(@() gemRandn([1,2,3]));
    
    assert(isequal(size(gemRandn(4, 5)), [4 5]));
    shouldProduceAnError(@() gemRandn([1 2],2));
    
    shouldProduceAnError(@() gemRandn(1,2,3));
end
