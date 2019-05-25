function test_suite = gem_workingPrecision_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_persistent_value
    a = gem.workingPrecision;
    
    gem.workingPrecision(1);
    assert(gem.workingPrecision == 1);

    gem.workingPrecision(1000);
    assert(gem.workingPrecision == 1000);
    
    gem.workingPrecision(5);
    assert(gem.workingPrecision == 5);

    gem.workingPrecision(a);
    assert(gem.workingPrecision == a);
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
