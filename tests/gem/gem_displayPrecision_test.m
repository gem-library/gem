function test_suite = gem_displayPrecision_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_persistent_value
    a = gem.displayPrecision;

    gem.displayPrecision(1);
    assert(gem.displayPrecision == 1);

    gem.displayPrecision(1000);
    assert(gem.displayPrecision == 1000);
    
    gem.displayPrecision(-1);
    assert(gem.displayPrecision == -1);
    
    gem.displayPrecision(a);
    assert(gem.displayPrecision == a);
end
