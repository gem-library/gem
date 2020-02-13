function test_suite = disp_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    x = generateMatrices(1, 5, {'A', 'AR', 'AI'});

    for i = 1:numel(x)
        assert(~isempty(evalc('disp(x{i});')));
        assert(~isempty(evalc('disp(x{i}, 4);')));
        assert(~isempty(evalc('disp(x{i}, -1);')));
        assert(~isempty(evalc('disp(x{i}, gem(4));')));
    end
end
