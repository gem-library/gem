function test_suite = sum_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    x = generateMatrices(10, 5, {'F', 'FR', 'FI', 'P'});
    validateDoubleConsistency(@(x) sum(full(x)), x);
    
    validateDoubleConsistency(@(x) sum(full(x), 1), x);
    
    validateDoubleConsistency(@(x) sum(full(x), 2), x);

    % Octave doesn't support the syntax sum(x, 'all')
    for i = 1:length(x)
        assert(max(max(abs( sum(full(x{i}),'all') - sum(sum(full(double(x{i})),1),2) ))) < 1e-9)
    end
end

function test_inputs
    try
        sum(gemRand, 'alll');
        assert(false);
    catch
    end
    
    try
        sum(gemRand, -1);
        assert(false);
    catch
    end
end

function test_type
    assert(isa(sum(gemRand(2)), 'gem'));
    assert(isa(sum(gemRand(2), 1, 'native'), 'gem'));
    assert(isa(sum(gemRand(2), 1, 'default'), 'gem'));
    assert(isa(sum(gemRand(2), 1, 'double'), 'double'));
    assert(isa(sum(gemRand(2), 2), 'gem'));
    assert(isa(sum(gemRand(2), 2, 'native'), 'gem'));
    assert(isa(sum(gemRand(2), 2, 'default'), 'gem'));
    assert(isa(sum(gemRand(2), 2, 'double'), 'double'));
    assert(isa(sum(gemRand(2), 'all'), 'gem'));
    assert(isa(sum(gemRand(2), 'all', 'native'), 'gem'));
    assert(isa(sum(gemRand(2), 'all', 'default'), 'gem'));
    assert(isa(sum(gemRand(2), 'all', 'double'), 'double'));
end
