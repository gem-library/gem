function test_suite = eig_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_inputs
    try
        eig(sgem(1));
        assert(false);
    catch
    end
end
