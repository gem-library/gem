function test_suite = cond_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    x = generateMatrices(2, 5, {'A', 'AR', 'AI'});
    %validateDoubleConsistency(@(x) abs(x), x); % FIRST FIX SVDS
end
