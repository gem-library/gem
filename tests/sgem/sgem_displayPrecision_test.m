function test_suite = sgem_displayPrecision_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_persistent_value
    a = sgem.displayPrecision;

    sgem.displayPrecision(1);
    assert(sgem.displayPrecision == 1);

    sgem.displayPrecision(1000);
    assert(sgem.displayPrecision == 1000);
    
    sgem.displayPrecision(-1);
    assert(sgem.displayPrecision == -1);
    
    sgem.displayPrecision(a);
    assert(sgem.displayPrecision == a);
end
