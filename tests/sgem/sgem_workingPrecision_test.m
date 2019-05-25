function test_suite = sgem_workingPrecision_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_persistent_value
    a = sgem.workingPrecision;
    
    sgem.workingPrecision(1);
    assert(sgem.workingPrecision == 1);

    sgem.workingPrecision(1000);
    assert(sgem.workingPrecision == 1000);
    
    sgem.workingPrecision(5);
    assert(sgem.workingPrecision == 5);

    sgem.workingPrecision(a);
    assert(sgem.workingPrecision == a);
end

function test_likeMatlab
    a = sgem.workingPrecision;
    
    sgem.workingPrecision(10);
    pi10 = sgem('pi');
    assert(precision(pi10) == 10);

    sgem.workingPrecision(20);
    pi20 = sgem('pi');
    assert(precision(pi20) == 20);

    assert(abs(pi10-pi20) < 2e-10);
    assert(abs(pi10-pi20) > 1e-10);
    
    sgem.workingPrecision(a);
end
