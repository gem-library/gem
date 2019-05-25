function test_suite = size_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    x = generateMatrices(2, 5, {'F', 'FR', 'FI'});
    for i = 1:numel(x)
        assert(isequal(size(x{i}), size(double(x{i}))));
        
        [a b] = size(x{i});
        [aD bD] = size(double(x{i}));
        assert(a == aD);
        assert(b == bD);
    end
end

function test_inputs
    shouldProduceAnError(@() size(gem([1 2 3]), 3));
end
