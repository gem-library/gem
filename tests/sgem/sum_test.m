function test_suite = sum_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    global fastTests
    if isempty(fastTests) || (fastTests == 0)
        x = generateMatrices(10, 5, {'P', 'PR', 'PI'});
    else
        x = generateMatrices(1, 5, {'P'});
    end
    
    validateDoubleConsistency(@(x) sum(x), x);

    validateDoubleConsistency(@(x) sum(x, 1), x);
    
    validateDoubleConsistency(@(x) sum(x, 2), x);

    % Octave doesn't support the syntax sum(x, 'all')
    for i = 1:length(x)
        assert(max(max(abs( sum(x{i},'all') - sum(sum(full(double(x{i})),1),2) ))) < 1e-9)
    end
end

function test_inputs
    shouldProduceAnError(@() sum(sparse(gem.rand), 'alll'));
    shouldProduceAnError(@() sum(sparse(gem.rand), -1));
end

function test_type
    assert(isa(sum(gem.rand(2)), 'gem'));
    assert(isa(sum(gem.rand(2), 1, 'native'), 'gem'));
    assert(isa(sum(gem.rand(2), 1, 'default'), 'gem'));
    assert(isa(sum(gem.rand(2), 1, 'double'), 'double'));
    assert(isa(sum(gem.rand(2), 2), 'gem'));
    assert(isa(sum(gem.rand(2), 2, 'native'), 'gem'));
    assert(isa(sum(gem.rand(2), 2, 'default'), 'gem'));
    assert(isa(sum(gem.rand(2), 2, 'double'), 'double'));
    assert(isa(sum(gem.rand(2), 'all'), 'gem'));
    assert(isa(sum(gem.rand(2), 'all', 'native'), 'gem'));
    assert(isa(sum(gem.rand(2), 'all', 'default'), 'gem'));
    assert(isa(sum(gem.rand(2), 'all', 'double'), 'double'));
end
