function test_suite = gt_test()
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
    validateDoubleConsistency(@(x) gt(x,x), x);
    validateDoubleConsistency(@(x) gt(rround(x),double(rround(x))), x);
    validateDoubleConsistency(@(x) gt(rround(x),double(sparse(rround(x)))), x);
    validateDoubleConsistency(@(x) gt(x,sparse(x)), x);
    validateDoubleConsistency(@(x) gt(double(rround(x)),rround(x)), x);
    
    % Octave doesn't support comparison with a scalar like matlab
    if ~isOctave
        validateDoubleConsistency(@(x) gt(x,x(1)), x);
        validateDoubleConsistency(@(x) gt(x(1),x), x);
    end
end

function test_sparseLikeMatlab
    initStatus = gem.sparseLikeMatlab;
    
    gem.sparseLikeMatlab(0);
    assert(~issparse(gt(gem([1 2]), sgem(-1))));
    gem.sparseLikeMatlab(1);
    assert(issparse(gt(gem([1 2]), sgem(-1))));
    
    gem.sparseLikeMatlab(initStatus);
end

function test_inputs
    x = gem.rand(3);
    
    % minimum and maximum 2 inputs
    shouldProduceAnError(@() gt(x));
    shouldProduceAnError(@() gt(x,x,x));

    % sizes should match
    shouldProduceAnError(@() gt(x, [1 2 3]));
end
