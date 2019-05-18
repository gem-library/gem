function test_suite = svd_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_inputs
    try
        svd(sgem(1));
        assert(false);
    catch
    end
end
