function test_suite = eig_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_inputs
    shouldProduceAnError(@() eig(sgem(1)));
end
