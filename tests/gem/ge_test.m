function test_suite = ge_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    x = generateMatrices(2, 5, {'F', 'FR', 'FI'});

    validateDoubleConsistency(@(x) ge(x,x), x);
    validateDoubleConsistency(@(x) ge(round(x),double(round(x))), x);
    validateDoubleConsistency(@(x) ge(round(x),double(sparse(round(x)))), x);
    validateDoubleConsistency(@(x) ge(x,sparse(x)), x);
    validateDoubleConsistency(@(x) ge(double(round(x)),round(x)), x);
    
    % Octave doesn't support comparison with a scalar like matlab
    isOctave = exist('OCTAVE_VERSION', 'builtin') ~= 0;
    if ~isOctave
        validateDoubleConsistency(@(x) ge(x,x(1)), x);
        validateDoubleConsistency(@(x) ge(x(1),x), x);
    end
end

function test_sparseLikeMatlab
    initStatus = gemSparseLikeMatlab;
    
    gemSparseLikeMatlab(0);
    assert(~issparse(ge(gem([1 2]), sgem(0))));
    gemSparseLikeMatlab(1);
    assert(issparse(ge(gem([1 2]), sgem(0))));
    
    gemSparseLikeMatlab(initStatus);
end

function test_inputs
    x = gemRand(3);
    
    % minimum and maximum 2 inputs
    shouldProduceAnError(@() ge(x));
    shouldProduceAnError(@() ge(x,x,x));

    % sizes should match
    shouldProduceAnError(@() ge(x, [1 2 3]));
end
