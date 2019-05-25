function test_suite = svd_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_inputs
    shouldProduceAnError(@() svd(sgem(1)));
end
