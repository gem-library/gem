function test_suite = plot_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    plot(gem([1 2]), gem([1 2]));
end
