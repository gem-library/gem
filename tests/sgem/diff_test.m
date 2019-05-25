function test_suite = diff_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    % Check if we are running octave: octave has some bugs which don't
    % allow us to perform all checks
    isOctave = exist('OCTAVE_VERSION', 'builtin') ~= 0;

    x = generateMatrices(2, 5, {'A', 'AR', 'AI', 'P', 'PR', 'PI'});

    validateDoubleConsistency(@(x) diff(x), x);
    validateDoubleConsistency(@(x) diff(x,1), x);
    if isOctave
        assert(sum(sum(abs(diff(sgem([1 2 4]),2) - diff(diff([1 2 4]))))) < 1e-3);
    else
        validateDoubleConsistency(@(x) diff(x,2), x);
        validateDoubleConsistency(@(x) diff(x,5), x);
        validateDoubleConsistency(@(x) diff(x,10), x);
    end

    validateDoubleConsistency(@(x) diff(x,1,1), x);
    validateDoubleConsistency(@(x) diff(x,2,1), x);
    validateDoubleConsistency(@(x) diff(x,3,1), x);
    validateDoubleConsistency(@(x) diff(x,10,1), x);
    
    validateDoubleConsistency(@(x) diff(x,1,2), x);
    validateDoubleConsistency(@(x) diff(x,2,2), x);
    validateDoubleConsistency(@(x) diff(x,3,2), x);
    validateDoubleConsistency(@(x) diff(x,10,2), x);
    
    x = {sgem([1 2 3])};
    validateDoubleConsistency(@(x) diff(x), x);
end

function test_empty
    assert(isempty(diff(sgem([]))))
end

function test_inputs
    shouldProduceAnError(@() diff(sgem([1 2 3]), 1.5));
    shouldProduceAnError(@() diff(sgem([1 2 3]), [1 2]));
    shouldProduceAnError(@() diff(sgem([1 2 3]), 1, 1.5));
    shouldProduceAnError(@() diff(sgem([1 2 3]), 1, [1 2]));
end
