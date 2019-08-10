function test_suite = precision_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_likeMatlab
    a = gem.workingPrecision;
    
    gem.workingPrecision(10);
    pi10 = gem('pi');
    assert(precision(pi10) == 10);

    gem.workingPrecision(20);
    pi20 = gem('pi');
    assert(precision(pi20) == 20);

    assert(abs(pi10-pi20) < 2e-10);
    assert(abs(pi10-pi20) > 1e-10);
    
    gem.workingPrecision(a);
end
