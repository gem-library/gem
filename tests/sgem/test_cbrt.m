function test_suite = test_cbrt()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    x = generateMatrices(2, 5, {'A', 'AR', 'AI'});

    % matlab doesn't support cbrt
    for i = 1:length(x)
        assert(max(abs(cbrt(x{i}) - double(x{i}).^(1/3)), [], 'all') < 1e-13);
    end
end
