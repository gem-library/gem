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
    if ~isOctave
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
end

function test_empty
    assert(isempty(diff(gem([]))))
end

function test_inputs
    shouldProduceAnError(@() diff(gem([1 2 3]), 1.5));
    shouldProduceAnError(@() diff(gem([1 2 3]), [1 2]));
    shouldProduceAnError(@() diff(gem([1 2 3]), 1, 1.5));
    shouldProduceAnError(@() diff(gem([1 2 3]), 1, [1 2]));
end
