function test_suite = gt_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    x = generateMatrices(2, 5, {'F', 'FR', 'FI'});

    validateDoubleConsistency(@(x) gt(x,x), x);
    validateDoubleConsistency(@(x) gt(round(x),double(round(x))), x);
    validateDoubleConsistency(@(x) gt(round(x),double(sparse(round(x)))), x);
    validateDoubleConsistency(@(x) gt(x,sparse(x)), x);
    validateDoubleConsistency(@(x) gt(double(round(x)),round(x)), x);
    
    validateDoubleConsistency(@(x) gt(x,x(1)), x);
    validateDoubleConsistency(@(x) gt(x(1),x), x);
end

function test_sparseLikeMatlab
    initStatus = gemSparseLikeMatlab;
    
    gemSparseLikeMatlab(0);
    assert(~issparse(gt(gem([1 2]), sgem(-1))));
    gemSparseLikeMatlab(1);
    assert(issparse(gt(gem([1 2]), sgem(-1))));
    
    gemSparseLikeMatlab(initStatus);
end

function test_inputs
    x = gemRand(3);
    
    % minimum and maximum 2 inputs
    shouldProduceAnError(@() gt(x));
    shouldProduceAnError(@() gt(x,x,x));

    % sizes should match
    shouldProduceAnError(@() gt(x, [1 2 3]));
end
