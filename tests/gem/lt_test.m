function test_suite = lt_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    x = generateMatrices(2, 5, {'F', 'FR', 'FI'});

    validateDoubleConsistency(@(x) lt(x,x), x);
    validateDoubleConsistency(@(x) lt(round(x),double(round(x))), x);
    validateDoubleConsistency(@(x) lt(round(x),double(sparse(round(x)))), x);
    validateDoubleConsistency(@(x) lt(x,sparse(x)), x);
    validateDoubleConsistency(@(x) lt(double(round(x)),round(x)), x);
    
    % Octave doesn't support comparison with a scalar like matlab
    isOctave = exist('OCTAVE_VERSION', 'builtin') ~= 0;
    if ~isOctave
        validateDoubleConsistency(@(x) lt(x,x(1)), x);
        validateDoubleConsistency(@(x) lt(x(1),x), x);
    end
end

function test_sparseLikeMatlab
    initStatus = gem.sparseLikeMatlab;
    
    gem.sparseLikeMatlab(0);
    assert(~issparse(lt(gem([1 2]), sgem(1))));
    gem.sparseLikeMatlab(1);
    assert(issparse(lt(gem([1 2]), sgem(1))));
    
    gem.sparseLikeMatlab(initStatus);
end

function test_inputs
    x = gem.rand(3);
    
    % minimum and maximum 2 inputs
    shouldProduceAnError(@() lt(x));
    shouldProduceAnError(@() lt(x,x,x));

    % sizes should match
    shouldProduceAnError(@() lt(x, [1 2 3]));
end
