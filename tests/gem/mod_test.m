function test_suite = mod_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    x = generateDoubleMatrices(2, 5, {'FR'});
    validateDoubleConsistency2(@(x,y) mod(x,y), x(1,:), x(2,:));
    validateDoubleConsistency2(@(x,y) mod(x,y(1,1)), x(1,:), x(2,:));
end
