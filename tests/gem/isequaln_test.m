function test_suite = isequaln_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    x = generateMatrices(2, 5, {'F', 'FR', 'FI'});

    validateDoubleConsistency(@(x) isequaln(x,x), x);
    validateDoubleConsistency(@(x) isequaln(x,x,x), x);

    validateDoubleConsistency(@(x) isequaln(x,real(x)), x);
    validateDoubleConsistency(@(x) isequaln(round(x),double(round(x))), x);
    validateDoubleConsistency(@(x) isequaln(double(round(x)),round(x)), x);
    validateDoubleConsistency2(@(x,y) isequaln(x,y), x, x([2:end 1]));
end

function test_precision
    x = gem.rand(3);
    
    previousPrecision = gem.workingPrecision;
    gem.workingPrecision(10);
    x2 = gem(double(x));
    
    assert(~isequaln(x,x2));
    
    gem.workingPrecision(previousPrecision);
end

function test_inputs
    x = gem.rand(3);
    
    % minimum 2 inputs
    shouldProduceAnError(@() isequaln(x));
end
