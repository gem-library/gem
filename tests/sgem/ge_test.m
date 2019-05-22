function test_suite = ge_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    x = generateMatrices(2, 5, {'A', 'AR', 'AI'});

    validateDoubleConsistency(@(x) ge(x,x), x);
    validateDoubleConsistency(@(x) ge(round(x),double(round(x))), x);
    validateDoubleConsistency(@(x) ge(round(x),double(sparse(round(x)))), x);
    validateDoubleConsistency(@(x) ge(x,sparse(x)), x);
    validateDoubleConsistency(@(x) ge(double(round(x)),round(x)), x);
    
    validateDoubleConsistency(@(x) ge(x,x(1)), x);
    validateDoubleConsistency(@(x) ge(x(1),x), x);
end

function test_sparseLikeMatlab
    initStatus = gemSparseLikeMatlab;
    
    gemSparseLikeMatlab(0);
    assert(~issparse(ge(sgem([1 2]), gem(0))));
    gemSparseLikeMatlab(1);
    assert(issparse(ge(sgem([1 2]), gem(0))));
    
    gemSparseLikeMatlab(initStatus);
end

function test_inputs
    x = sparse(gemRand(3));
    
    % minimum and maximum 2 inputs
    shouldProduceAnError(@() ge(x));
    shouldProduceAnError(@() ge(x,x,x));

    % sizes should match
    shouldProduceAnError(@() ge(x, [1 2 3]));
end
