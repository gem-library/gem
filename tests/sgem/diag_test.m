function test_suite = diag_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    x = generateMatrices(2, 5, {'A', 'AR', 'AI'});

    % Let us extract or create some diagonals
    validateDoubleConsistency(@(x) diag(x), x);
    validateDoubleConsistency(@(x) diag(x,1), x);
    validateDoubleConsistency(@(x) diag(x,5), x);
    validateDoubleConsistency(@(x) diag(x,10), x);
    validateDoubleConsistency(@(x) diag(x,-1), x);
    validateDoubleConsistency(@(x) diag(x,-5), x);
    validateDoubleConsistency(@(x) diag(x,-10), x);
    
    % Let us make sure we create some matrices also
    validateDoubleConsistency(@(x) diag(x(:)), x);
    validateDoubleConsistency(@(x) diag(x(:),1), x);
    validateDoubleConsistency(@(x) diag(x(:),5), x);
    validateDoubleConsistency(@(x) diag(x(:)',-1), x);
    validateDoubleConsistency(@(x) diag(x(:)',-5), x);
end

function test_empty
    assert(isempty(diag(sgem([]))))
end

function test_inputs
    shouldProduceAnError(@() diag(sgem(1), 1.5));
end
