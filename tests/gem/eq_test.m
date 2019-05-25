function test_suite = eq_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    x = generateMatrices(2, 5, {'F', 'FR', 'FI'});

    validateDoubleConsistency(@(x) eq(x,x), x);
    validateDoubleConsistency(@(x) eq(round(x),double(round(x))), x);
    validateDoubleConsistency(@(x) eq(round(x),double(sparse(round(x)))), x);
    validateDoubleConsistency(@(x) eq(x,sparse(x)), x);
    validateDoubleConsistency(@(x) eq(double(round(x)),round(x)), x);
    
    validateDoubleConsistency(@(x) eq(x,x(1)), x);
    validateDoubleConsistency(@(x) eq(x(1),x), x);
end

function test_sparseLikeMatlab
    initStatus = gemSparseLikeMatlab;
    
    gemSparseLikeMatlab(0);
    assert(~issparse(eq(gem([1 2]), sgem(0))));
    gemSparseLikeMatlab(1);
    assert(issparse(eq(gem([1 2]), sgem(0))));
    
    gemSparseLikeMatlab(initStatus);
end

function test_inputs
    x = gemRand(3);
    
    % minimum and maximum 2 inputs
    shouldProduceAnError(@() eq(x));
    shouldProduceAnError(@() eq(x,x,x));

    % sizes should match
    shouldProduceAnError(@() plus(x, [1 2 3]));
end
