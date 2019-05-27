function test_suite = complex_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    x = generateMatrices(2, 5, {'A', 'AR', 'AI'});
    % matlab doesn't support sparse input for complex...
    for i = 1:length(x)
        assert(max(abs(complex(x{i}) - complex(full(x{i}))), [], 'all') < 1e-13);
    end

    y = generateMatrices(2, 5, {'AR'}, 2);
    % matlab doesn't support sparse input for complex...
    for i = 1:size(y,2)
        assert(max(abs(complex(y{1,i}, y{2,i}) - complex(full(y{1,i}), full(y{2,i}))), [], 'all') < 1e-13);
    end
end
