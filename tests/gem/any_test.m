function test_suite = any_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    x = generateMatrices(10, 5, {'F', 'FR', 'FI', 'P'});
    validateDoubleConsistency(@(x) any(full(x)), x);

    validateDoubleConsistency(@(x) any(full(x), 1), x);
    
    validateDoubleConsistency(@(x) any(full(x), 2), x);

    % Octave doesn't support the syntax any(x, 'all')
    for i = 1:length(x)
        assert(max(max(abs( any(full(x{i}),'all') - any(any(full(double(x{i})),1),2) ))) < 1e-9)
    end
end

function test_inputs
    shouldProduceAnError(@() any(gem.rand, 'alll'));
    shouldProduceAnError(@() any(gem.rand, -1));
end
