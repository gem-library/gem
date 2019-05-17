function test_suite = diff_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    x = generateMatrices(2, 5, {'A', 'AR', 'AI', 'P', 'PR', 'PI'});

    validateDoubleConsistency(@(x) diff(x), x);
    validateDoubleConsistency(@(x) diff(x,1), x);
    validateDoubleConsistency(@(x) diff(x,2), x);
    validateDoubleConsistency(@(x) diff(x,5), x);
    validateDoubleConsistency(@(x) diff(x,10), x);

    validateDoubleConsistency(@(x) diff(x,1,1), x);
    validateDoubleConsistency(@(x) diff(x,2,1), x);
    validateDoubleConsistency(@(x) diff(x,3,1), x);
    validateDoubleConsistency(@(x) diff(x,10,1), x);
    
    validateDoubleConsistency(@(x) diff(x,1,2), x);
    validateDoubleConsistency(@(x) diff(x,2,2), x);
    validateDoubleConsistency(@(x) diff(x,3,2), x);
    validateDoubleConsistency(@(x) diff(x,10,2), x);
end

function test_empty
    assert(isempty(diff(gem([]))))
end

function test_inputs
    try
        diff(gem([1 2 3]), 1.5);
        assert(false);
    catch
    end
    
    try
        diff(gem([1 2 3]), [1 2]);
        assert(false);
    catch
    end
    
    try
        diff(gem([1 2 3]), 1, 1.5);
        assert(false);
    catch
    end
    
    try
        diff(gem([1 2 3]), 1, [1 2]);
        assert(false);
    catch
    end
end
