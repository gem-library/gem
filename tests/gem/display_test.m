function test_suite = display_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    x = generateMatrices(1, 5, {'F', 'FR', 'FI'});
    
    for i = 1:numel(x)
        assert(~isempty(evalc('display(x{i})')));

        assert(~isempty(evalc('display(x{i}, 4);')));
        assert(~isempty(evalc('display(x{i}, -1);')));
        assert(~isempty(evalc('display(x{i}, gem(4));')));

        assert(~isempty(evalc('display(x{i}, ''name'');')));

        assert(~isempty(evalc('display(x{i}, ''name'', 4);')));
        assert(~isempty(evalc('display(x{i}, ''name'', -1);')));
        assert(~isempty(evalc('display(x{i}, ''name'', gem(4));')));
    end
end
