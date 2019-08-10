function test_suite = eps_test()
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
    sgem.workingPrecision(50);
    assert(abs(eps(pi10) - 1e-10) < 1e-40);

    sgem.workingPrecision(20);
    pi20 = [0 sgem('pi')];
    sgem.workingPrecision(50);
    assert(abs(eps(pi20) - 1e-20) < 1e-40);
    
    sgem.workingPrecision(a);
end
