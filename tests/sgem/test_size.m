function test_suite = test_size()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    x = generateMatrices(2, 5, {'A', 'AR', 'AI'});
    for i = 1:numel(x)
        assert(isequal(size(x{i}), size(double(x{i}))));
    end
end
