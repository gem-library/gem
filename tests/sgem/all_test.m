function test_suite = all_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    x = generateMatrices(10, 5, {'P', 'PR', 'PI'});
    validateDoubleConsistency(@(x) all(x), x);

    validateDoubleConsistency(@(x) all(x, 1), x);
    
    validateDoubleConsistency(@(x) all(x, 2), x);

    % Octave doesn't support the syntax all(x, 'all')
    for i = 1:length(x)
        assert(max(max(abs( all(x{i},'all') - all(all(full(double(x{i})),1),2) ))) < 1e-9)
    end
end

function test_inputs
    shouldProduceAnError(@() all(sparse(gem.rand), 'alll'));
    shouldProduceAnError(@() all(sparse(gem.rand), -1));
end
