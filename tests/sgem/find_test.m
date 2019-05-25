function test_suite = find_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    x = generateMatrices(2, 5, {'A', 'AR', 'AI'});
    
    validateDoubleConsistency(@(x) find(x), x);
    validateDoubleConsistency(@(x) find(x, 1), x);
    validateDoubleConsistency(@(x) find(x, 2), x);
    validateDoubleConsistency(@(x) find(x, gem(1), 'first'), x);
    validateDoubleConsistency(@(x) find(x, sgem(2), 'first'), x);
    validateDoubleConsistency(@(x) find(x, 1, 'last'), x);
    validateDoubleConsistency(@(x) find(x, 2, 'last'), x);

    for i = 1:length(x)
        [I J V] = find(x{i}, 2);
        [ID JD VD] = find(double(x{i}), min(numel(x{i}),2)); % it seems that Octave doesn't always support specifying more elements than the number of elements in sparse matrices...
        assert(max(max(abs(I - ID))) < 1e-6);
        assert(max(max(abs(J - JD))) < 1e-6);
        assert(max(max(abs(V - VD))) < 1e-6);

        [I J V] = find(x{i}, 2, 'last');
        [ID JD VD] = find(double(x{i}), min(numel(x{i}),2), 'last');
        assert(max(max(abs(I - ID))) < 1e-6);
        assert(max(max(abs(J - JD))) < 1e-6);
        assert(max(max(abs(V - VD))) < 1e-6);
    end
end

function test_empty
    assert(isempty(find(sgem([]))));
end

function test_inputs
    % second input should be a scalar
    shouldProduceAnError(@() find(sgem([1 2 3]), [1 2]));
    
    % third input cannot be anything
    shouldProduceAnError(@() find(sgem([1 2 3]), 1, 'beginning'));
end
