function test_suite = complex_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    x = generateMatrices(2, 5, {'F', 'FR', 'FI'});
    validateDoubleConsistency(@(x) complex(x), x);
    
    y = generateMatrices(2, 5, {'FR'}, 2);
    validateDoubleConsistency2(@(x,y) complex(x,y), y(1,:), y(2,:))
end
