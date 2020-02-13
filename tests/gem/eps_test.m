function test_suite = eps_test()
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
    gem.workingPrecision(50);
    assert(abs(eps(pi10) - 1e-10) < 1e-40);

    gem.workingPrecision(20);
    pi20 = gem('pi');
    gem.workingPrecision(50);
    assert(abs(eps(pi20) - 1e-20) < 1e-40);
    
    gem.workingPrecision(a);
end
