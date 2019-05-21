function test_suite = mpower_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    x = generateMatrices(2, 5, {'F', 'FR', 'FI'});

    % A few scalar cases
    r = gemRand;
    validateDoubleConsistency(@(x) mpower(x(1), r), x);
    r = -gemRand;
    validateDoubleConsistency(@(x) mpower(x(1), r), x);
    r = gemRand*1i;
    validateDoubleConsistency(@(x) mpower(x(1), r), x);
    r = -gemRand + gemRand*1i;
    validateDoubleConsistency(@(x) mpower(x(1), r), x);
    
    % We currently also support two cases for square matrices
    x = generateMatrices(2, 5, {'QF', 'QFR', 'QFI'});
    for i = 1:numel(x)
        assert(max(max(abs( mpower(x{i},1) - x{i} ))) < 1e-5);
        assert(max(max(abs( mpower(x{i},-1) - inv(double(x{i})) ))) < 1e-5);
    end
end

function test_empty
    assert(isempty(gem([])^gem([])));
end

function test_inputs
    x = gemRand(3);
    
    % minimum and maximum 2 inputs
    shouldProduceAnError(@() mpower(x));
    shouldProduceAnError(@() mpower(x,x,x));
    
    % sizes should match
    shouldProduceAnError(@() mpower(x, [1 2 3]));
end
