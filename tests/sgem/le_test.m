function test_suite = le_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    x = generateMatrices(2, 5, {'A', 'AR', 'AI'});

    validateDoubleConsistency(@(x) le(x,x), x);
    validateDoubleConsistency(@(x) le(round(x),double(round(x))), x);
    validateDoubleConsistency(@(x) le(round(x),double(sparse(round(x)))), x);
    validateDoubleConsistency(@(x) le(x,sparse(x)), x);
    validateDoubleConsistency(@(x) le(double(round(x)),round(x)), x);
    
    validateDoubleConsistency(@(x) le(x,x(1)), x);
    validateDoubleConsistency(@(x) le(x(1),x), x);
end

function test_sparseLikeMatlab
    initStatus = gemSparseLikeMatlab;
    
    gemSparseLikeMatlab(0);
    assert(~issparse(le(sgem([1 2]), gem(0))));
    gemSparseLikeMatlab(1);
    assert(issparse(le(sgem([1 2]), gem(0))));
    
    gemSparseLikeMatlab(initStatus);
end

function test_inputs
    x = sparse(gemRand(3));
    
    % minimum and maximum 2 inputs
    shouldProduceAnError(@() le(x));
    shouldProduceAnError(@() le(x,x,x));

    % sizes should match
    shouldProduceAnError(@() le(x, [1 2 3]));
end
