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
    end
end
