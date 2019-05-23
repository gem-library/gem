function test_suite = plot_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    plot(sgem([1 2]), sgem([1 2]));
end
