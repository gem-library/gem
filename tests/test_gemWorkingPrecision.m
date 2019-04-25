function test_suite = test_gemWorkingPrecision()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_persistent_value
    a = gemWorkingPrecision;
    gemWorkingPrecision(1);
    assert(gemWorkingPrecision == 1);
    gemWorkingPrecision(1000);
    assert(gemWorkingPrecision == 1000);
    gemWorkingPrecision(a);
    assert(gemWorkingPrecision == a);
end

function test_likeMatlab
    a = gemWorkingPrecision;
    
    gemWorkingPrecision(10);
    pi10 = gem('pi');
    assert(precision(pi10) == 10);

    gemWorkingPrecision(20);
    pi20 = gem('pi');
    assert(precision(pi20) == 20);

    assert(abs(pi10-pi20) < 2e-10);
    assert(abs(pi10-pi20) > 1e-10);
    
    gemWorkingPrecision(a);
end
