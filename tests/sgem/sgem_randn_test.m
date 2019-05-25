function test_suite = sgem_randn_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_inputs
    assert(isequal(size(sgem.randn), [1 1]));
    assert(isequal(size(sgem.randn(3)), [3 3]));
    assert(isequal(size(sgem.randn([4 5])), [4 5]));
    shouldProduceAnError(@() sgem.randn([1,2,3]));
    
    assert(isequal(size(sgem.randn(4, 5)), [4 5]));
    shouldProduceAnError(@() sgem.randn([1 2],2));
    
    shouldProduceAnError(@() sgem.randn(1,2,3));
end
