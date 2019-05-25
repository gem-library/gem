function test_suite = sort_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    x = generateMatrices(2, 5, {'F', 'FR', 'FI'});
    
    validateDoubleConsistency(@(x) sort(x), x);
    validateDoubleConsistency(@(x) sort(x, 1), x);
    validateDoubleConsistency(@(x) sort(x, 2), x);
    validateDoubleConsistency(@(x) sort(x, gem(1), 'ascend'), x);
    validateDoubleConsistency(@(x) sort(x, sgem(2), 'ascend'), x);
    validateDoubleConsistency(@(x) sort(x, 1, 'descend'), x);
    validateDoubleConsistency(@(x) sort(x, 2, 'descend'), x);
    validateDoubleConsistency(@(x) sort(x, 'ascend'), x);
    validateDoubleConsistency(@(x) sort(x, 'descend'), x);

    % Octave doesn't support sorting a singleton dimension
    isOctave = exist('OCTAVE_VERSION', 'builtin') ~= 0;
    if isOctave
        for i = 1:length(x)
            [a I] = sort(x{i}, 3);
            assert(max(max(abs(a - x{i}))) < 1e-6);
            assert(max(max(abs(I - ones(size(x{i}))))) < 1e-6);
        end
    else
        for i = 1:length(x)
            [a I] = sort(x{i}, 3);
            [aD ID] = sort(double(x{i}), 3);
            assert(max(max(abs(a - aD))) < 1e-6);
            assert(max(max(abs(I - ID))) < 1e-6);
        end
    end
end

function test_empty
    assert(isempty(sort(gem([]))));
end

function test_inputs
    % mode should be 'ascend' or 'descend'
    shouldProduceAnError(@() sort(gem([1 2 3]), 1, 'inverted'));
    
    % dimension should be a scalar
    shouldProduceAnError(@() sort(gem([1 2 3]), [1 2]));
end
