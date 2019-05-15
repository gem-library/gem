function test_suite = prod_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    x = generateMatrices(2, 3, {'P', 'PR', 'PI', 'A', 'AR', 'AI'});
    validateDoubleConsistency(@(x) prod(x), x, 1e-9);

    validateDoubleConsistency(@(x) prod(x, 1), x, 1e-9);
    
    validateDoubleConsistency(@(x) prod(x, 2), x, 1e-9);

    % Octave doesn't support the syntax prod(x, 'all')
    for i = 1:length(x)
        assert(max(max(abs( prod(x{i},'all') - prod(prod(full(double(x{i})),1),2) ))) < 1e-3)
    end
end

function test_inputs
    try
        prod(sparse(gemRand), 'alll');
        assert(false);
    catch
    end
    
    try
        prod(sparse(gemRand), -1);
        assert(false);
    catch
    end
end
