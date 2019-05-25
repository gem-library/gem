function test_suite = eq_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    x = generateMatrices(2, 5, {'A', 'AR', 'AI'});

    validateDoubleConsistency(@(x) eq(x,x), x);
    validateDoubleConsistency(@(x) eq(round(x),double(round(x))), x);
    validateDoubleConsistency(@(x) eq(round(x),double(full(round(x)))), x);
    validateDoubleConsistency(@(x) eq(x,full(x)), x);
    validateDoubleConsistency(@(x) eq(double(round(x)),round(x)), x);
    
    validateDoubleConsistency(@(x) eq(x,x(1)), x);
    validateDoubleConsistency(@(x) eq(x(1),x), x);
end

function test_sparseLikeMatlab
    initStatus = gem.sparseLikeMatlab;
    
    gem.sparseLikeMatlab(0);
    assert(~issparse(eq(sgem([1 2]), gem(0))));
    gem.sparseLikeMatlab(1);
    assert(issparse(eq(sgem([1 2]), gem(0))));
    
    gem.sparseLikeMatlab(initStatus);
end

function test_inputs
    x = sparse(gem.rand(3));
    
    % minimum and maximum 2 inputs
    shouldProduceAnError(@() eq(x));
    shouldProduceAnError(@() eq(x,x,x));

    % sizes should match
    shouldProduceAnError(@() plus(x, [1 2 3]));
end
