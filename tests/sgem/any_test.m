function test_suite = any_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    x = generateMatrices(10, 5, {'P', 'PR', 'PI'});
    validateDoubleConsistency(@(x) any(x), x);
    
    validateDoubleConsistency(@(x) any(x, 1), x);
    
    validateDoubleConsistency(@(x) any(x, 2), x);

    % Octave doesn't support the syntax any(x, 'all')
    for i = 1:length(x)
        assert(max(max(abs( any(x{i},'all') - any(any(full(double(x{i})),1),2) ))) < 1e-9)
    end
end

function test_inputs
    shouldProduceAnError(@() any(sparse(gem.rand), 'alll'));
    shouldProduceAnError(@() any(sparse(gem.rand), -1));
end
