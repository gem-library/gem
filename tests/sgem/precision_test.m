function test_suite = precision_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_likeMatlab
    a = sgem.workingPrecision;
    
    sgem.workingPrecision(10);
    pi10 = sgem('pi');
    assert(precision(pi10) == 10);

    sgem.workingPrecision(20);
    pi20 = [0 sgem('pi')];
    assert(isequal(precision(pi20), [0 20]));

    assert(abs(pi10-pi20(2)) < 2e-10);
    assert(abs(pi10-pi20(2)) > 1e-10);
    
    sgem.workingPrecision(a);
end
