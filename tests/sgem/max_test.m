function test_suite = max_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    % Check if we are running octave: octave doesn't support max with 'all'
    % parameter, and it doesn't support max with a scalar for sparse
    % objects
    isOctave = exist('OCTAVE_VERSION', 'builtin') ~= 0;

    x = generateMatrices(2, 5, {'P', 'PR', 'PI'});
    
    validateDoubleConsistency(@(x) max(x), x);
    validateDoubleConsistency(@(x) max(x, [], 1), x);
    validateDoubleConsistency(@(x) max(x, [], 2), x);

    % element-wise maximum between two matrices
    y = generateDoubleMatrices(2, 5, {'P', 'PR', 'PI'});
    validateDoubleConsistency2(@(x,y) max(x,y), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) max(x,sparse(y)), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) max(x,double(y)), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) max(x,double(sparse(y))), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) max(double(x),y), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) max(double(sparse(x)),y), y(1,:), y(2,:));

    % max with a scalar
    validateDoubleConsistency2(@(x,y) max(x,y(1)), y(1,:), y(2,:), 1e-12, 0, isOctave);
    validateDoubleConsistency2(@(x,y) max(x,sparse(y(1))), y(1,:), y(2,:), 1e-12, 0, isOctave);
    validateDoubleConsistency2(@(x,y) max(x,double(y(1))), y(1,:), y(2,:), 1e-12, 0, isOctave);
    validateDoubleConsistency2(@(x,y) max(x,double(sparse(y(1)))), y(1,:), y(2,:), 1e-12, 0, isOctave);
    validateDoubleConsistency2(@(x,y) max(double(x),y(1)), y(1,:), y(2,:), 1e-12, 0, isOctave);
    validateDoubleConsistency2(@(x,y) max(double(sparse(x)),y(1)), y(1,:), y(2,:), 1e-12, 0, isOctave);

    validateDoubleConsistency2(@(x,y) max(x(1),y), y(1,:), y(2,:), 1e-12, 0, isOctave);
    validateDoubleConsistency2(@(x,y) max(x(1),sparse(y)), y(1,:), y(2,:), 1e-12, 0, isOctave);
    validateDoubleConsistency2(@(x,y) max(x(1),double(y)), y(1,:), y(2,:), 1e-12, 0, isOctave);
    validateDoubleConsistency2(@(x,y) max(x(1),double(sparse(y))), y(1,:), y(2,:), 1e-12, 0, isOctave);
    validateDoubleConsistency2(@(x,y) max(double(x(1)),y), y(1,:), y(2,:), 1e-12, 0, isOctave);
    validateDoubleConsistency2(@(x,y) max(double(sparse(x(1))),y), y(1,:), y(2,:), 1e-12, 0, isOctave);
    
    if isOctave
        for i = 1:length(x)
            assert(abs(max(x{i}, [], 'all') - max(max(double(x{i})))) < 1e-5);
        end
    else
        validateDoubleConsistency(@(x) max(x, [], 'all'), x);
    end
end

function test_empty
    [Y I] = max(sgem([]));
    assert(isempty(Y));
    assert(isempty(I));
end

function test_inputs
    x = sparse(gemRand(3));
    
    % maximum 3 inputs
    shouldProduceAnError(@() max(x, 2, 3, 4));
    
    % second input should be empty if there is a third input
    shouldProduceAnError(@() max(x, 1, 1));

    % second input should be numeric
    shouldProduceAnError(@() max(x, 'all'));

    % second input should be of same size as the first one or a scalar
    shouldProduceAnError(@() max(x, [1 2]));

    % for an element-wise comparison, a single output is produced
    try
        [a b] = max(x, 1);
        error('The error test failed')
    catch me
        if isequal(me.message, 'The error test failed')
            assert(false);
        end
    end
end

function test_sparseLikeMatlab
    initStatus = gemSparseLikeMatlab;
    
    gemSparseLikeMatlab(0);
    assert(isa(max(sgem(3), gem([1 2])), 'gem'));
    gemSparseLikeMatlab(1);
    assert(isa(max(sgem(3), gem([1 2])), 'sgem'));
    
    gemSparseLikeMatlab(initStatus);
end
