function test_suite = prod_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    x = generateMatrices(2, 3, {'F', 'FR', 'FI', 'P'});
    validateDoubleConsistency(@(x) prod(full(x)), x, 1e-9);
    
    validateDoubleConsistency(@(x) prod(full(x), 1), x, 1e-9);
    
    validateDoubleConsistency(@(x) prod(full(x), 2), x, 1e-9);

    % Octave doesn't support the syntax prod(x, 'all')
    for i = 1:length(x)
        assert(max(max(abs( prod(full(x{i}),'all') - prod(prod(full(double(x{i})),1),2) ))) < 1e-3)
    end
end

function test_inputs
    shouldProduceAnError(@() prod(gemRand, 'alll'));

    shouldProduceAnError(@() prod(gemRand, -1));
end
