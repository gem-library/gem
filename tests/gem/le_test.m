function test_suite = le_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    x = generateMatrices(2, 5, {'F', 'FR', 'FI'});

    % Octave bugs if we don't do this
    isOctave = exist('OCTAVE_VERSION', 'builtin') ~= 0;
    if isOctave
        rround = @(x) round(round(x) + 1e-5 + 1e-5i);
    else
        rround = @(x) round(x);
    end
    validateDoubleConsistency(@(x) le(x,x), x);
    validateDoubleConsistency(@(x) le(rround(x),double(rround(x))), x);
    validateDoubleConsistency(@(x) le(rround(x),double(sparse(rround(x)))), x);
    validateDoubleConsistency(@(x) le(x,sparse(x)), x);
    validateDoubleConsistency(@(x) le(double(rround(x)),rround(x)), x);
    
    % Octave doesn't support comparison with a scalar like matlab
    if ~isOctave
        validateDoubleConsistency(@(x) le(x,x(1)), x);
        validateDoubleConsistency(@(x) le(x(1),x), x);
    end
end

function test_sparseLikeMatlab
    initStatus = gem.sparseLikeMatlab;
    
    gem.sparseLikeMatlab(0);
    assert(~issparse(le(gem([1 2]), sgem(0))));
    gem.sparseLikeMatlab(1);
    assert(issparse(le(gem([1 2]), sgem(0))));
    
    gem.sparseLikeMatlab(initStatus);
end

function test_inputs
    x = gem.rand(3);
    
    % minimum and maximum 2 inputs
    shouldProduceAnError(@() le(x));
    shouldProduceAnError(@() le(x,x,x));

    % sizes should match
    shouldProduceAnError(@() le(x, [1 2 3]));
end
