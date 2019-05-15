function test_suite = cbrt_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    x = generateMatrices(2, 5, {'F', 'FR', 'FI'});

    % matlab doesn't support cbrt
    for i = 1:length(x)
        assert(max(abs(cbrt(x{i}) - double(x{i}).^(1/3)), [], 'all') < 1e-13);
    end
end
