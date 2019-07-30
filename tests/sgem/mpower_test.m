function test_suite = mpower_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    x = generateMatrices(2, 5, {'A', 'AR', 'AI'});

    % A few scalar cases
    r = gem.rand;
    validateDoubleConsistency(@(x) mpower(x(1), r), x);
    r = -gem.rand;
    validateDoubleConsistency(@(x) mpower(x(1), r), x);
    r = gem.rand*1i;
    validateDoubleConsistency(@(x) mpower(x(1), r), x);
    r = -gem.rand + gem.rand*1i;
    validateDoubleConsistency(@(x) mpower(x(1), r), x);
    
    % We currently also support two cases for square matrices
    x = generateMatrices(2, 5, {'QA', 'QAR', 'QAI'});
    for i = 1:numel(x)
        assert(max(max(abs( mpower(x{i},1) - x{i} ))) < 1e-5);
        assert(max(max(abs( mpower(x{i},-1) - inv(double(x{i})) ))) < 1e-5);
    end
end

function test_empty
    assert(isempty(sgem([])^sgem([])));
end

function test_inputs
    x = sparse(gem.rand(3));
    
    % minimum and maximum 2 inputs
    shouldProduceAnError(@() mpower(x));
    shouldProduceAnError(@() mpower(x,x,x));
    
    % sizes should match
    shouldProduceAnError(@() mpower(x, [1 2 3]));
end
