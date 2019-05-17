function test_suite = display_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    x = generateMatrices(2, 5, {'A', 'AR', 'AI', 'P', 'PR', 'PI'});

    for i = 1:numel(x)
        display(x{i});

        display(x{i}, 4);
        display(x{i}, -1);
        display(x{i}, gem(4));

        display(x{i}, 'name');

        display(x{i}, 'name', 4);
        display(x{i}, 'name', -1);
        display(x{i}, 'name', gem(4));
    end
end
