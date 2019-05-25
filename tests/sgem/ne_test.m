function test_suite = ne_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    x = generateMatrices(2, 5, {'A', 'AR', 'AI'});

    validateDoubleConsistency(@(x) ne(x,x), x);
    validateDoubleConsistency(@(x) ne(round(x),double(round(x))), x);
    validateDoubleConsistency(@(x) ne(round(x),double(full(round(x)))), x);
    validateDoubleConsistency(@(x) ne(x,full(x)), x);
    validateDoubleConsistency(@(x) ne(double(round(x)),round(x)), x);
    
    validateDoubleConsistency(@(x) ne(x,x(1)), x);
    validateDoubleConsistency(@(x) ne(x(1),x), x);
end

function test_sparseLikeMatlab
    initStatus = gem.sparseLikeMatlab;
    
    gem.sparseLikeMatlab(0);
    assert(~issparse(ne(sgem([1 2]), gem(1))));
    gem.sparseLikeMatlab(1);
    assert(issparse(ne(sgem([1 2]), gem(1))));
    
    gem.sparseLikeMatlab(initStatus);
end

function test_inputs
    x = sparse(gem.rand(3));
    
    % minimum and maximum 2 inputs
    shouldProduceAnError(@() ne(x));
    shouldProduceAnError(@() ne(x,x,x));

    % sizes should match
    shouldProduceAnError(@() ne(x, [1 2 3]));
end
