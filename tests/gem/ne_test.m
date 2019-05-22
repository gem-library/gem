function test_suite = ne_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    x = generateMatrices(2, 5, {'F', 'FR', 'FI'});

    validateDoubleConsistency(@(x) ne(x,x), x);
    validateDoubleConsistency(@(x) ne(round(x),double(round(x))), x);
    validateDoubleConsistency(@(x) ne(round(x),double(sparse(round(x)))), x);
    validateDoubleConsistency(@(x) ne(x,sparse(x)), x);
    validateDoubleConsistency(@(x) ne(double(round(x)),round(x)), x);
    
    validateDoubleConsistency(@(x) ne(x,x(1)), x);
    validateDoubleConsistency(@(x) ne(x(1),x), x);
end

function test_sparseLikeMatlab
    initStatus = gemSparseLikeMatlab;
    
    gemSparseLikeMatlab(0);
    assert(~issparse(ne(gem([1 2]), sgem(1))));
    gemSparseLikeMatlab(1);
    assert(issparse(ne(gem([1 2]), sgem(1))));
    
    gemSparseLikeMatlab(initStatus);
end

function test_inputs
    x = gemRand(3);
    
    % minimum and maximum 2 inputs
    shouldProduceAnError(@() ne(x));
    shouldProduceAnError(@() ne(x,x,x));

    % sizes should match
    shouldProduceAnError(@() ne(x, [1 2 3]));
end
