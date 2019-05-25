function test_suite = isempty_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    x = generateMatrices(2, 5, {'F', 'FR', 'FI'});
    x = cat(2, x, gem([]), gem(zeros(0,5)), gem(zeros(5,0)));
    validateDoubleConsistency(@(x) isempty(x), x);
end
