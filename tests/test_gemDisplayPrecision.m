function test_suite = test_gemDisplayPrecision()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_persistent_value
    a = gemDisplayPrecision;
    gemDisplayPrecision(1);
    assert(gemDisplayPrecision == 1);
    gemDisplayPrecision(1000);
    assert(gemDisplayPrecision == 1000);
    gemDisplayPrecision(-1);
    assert(gemDisplayPrecision == -1);
    gemDisplayPrecision(a);
    assert(gemDisplayPrecision == a);
end

