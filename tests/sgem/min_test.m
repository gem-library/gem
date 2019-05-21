function test_suite = min_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    % Check if we are running octave: octave doesn't support min with 'all'
    % parameter, and it doesn't support min with a scalar for sparse
    % objects
    isOctave = exist('OCTAVE_VERSION', 'builtin') ~= 0;

    x = generateMatrices(2, 5, {'P', 'PR', 'PI'});
    
    validateDoubleConsistency(@(x) min(x), x);
    validateDoubleConsistency(@(x) min(x, [], 1), x);
    validateDoubleConsistency(@(x) min(x, [], 2), x);

    % element-wise minimum between two matrices
    y = generateDoubleMatrices(2, 5, {'P', 'PR', 'PI'});
    validateDoubleConsistency2(@(x,y) min(x,y), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) min(x,sparse(y)), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) min(x,double(y)), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) min(x,double(sparse(y))), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) min(double(x),y), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) min(double(sparse(x)),y), y(1,:), y(2,:));

    % min with a scalar
    validateDoubleConsistency2(@(x,y) min(x,y(1)), y(1,:), y(2,:), 1e-12, 0, isOctave);
    validateDoubleConsistency2(@(x,y) min(x,sparse(y(1))), y(1,:), y(2,:), 1e-12, 0, isOctave);
    validateDoubleConsistency2(@(x,y) min(x,double(y(1))), y(1,:), y(2,:), 1e-12, 0, isOctave);
    validateDoubleConsistency2(@(x,y) min(x,double(sparse(y(1)))), y(1,:), y(2,:), 1e-12, 0, isOctave);
    validateDoubleConsistency2(@(x,y) min(double(x),y(1)), y(1,:), y(2,:), 1e-12, 0, isOctave);
    validateDoubleConsistency2(@(x,y) min(double(sparse(x)),y(1)), y(1,:), y(2,:), 1e-12, 0, isOctave);

    validateDoubleConsistency2(@(x,y) min(x(1),y), y(1,:), y(2,:), 1e-12, 0, isOctave);
    validateDoubleConsistency2(@(x,y) min(x(1),sparse(y)), y(1,:), y(2,:), 1e-12, 0, isOctave);
    validateDoubleConsistency2(@(x,y) min(x(1),double(y)), y(1,:), y(2,:), 1e-12, 0, isOctave);
    validateDoubleConsistency2(@(x,y) min(x(1),double(sparse(y))), y(1,:), y(2,:), 1e-12, 0,isOctave);
    validateDoubleConsistency2(@(x,y) min(double(x(1)),y), y(1,:), y(2,:), 1e-12, 0, isOctave);
    validateDoubleConsistency2(@(x,y) min(double(sparse(x(1))),y), y(1,:), y(2,:), 1e-12, 0, isOctave);
    
    if isOctave
        for i = 1:length(x)
            assert(abs(min(x{i}, [], 'all') - min(min(double(x{i})))) < 1e-5);
        end
    else
        validateDoubleConsistency(@(x) min(x, [], 'all'), x);
    end
end

function test_empty
    [Y I] = min(sgem([]));
    assert(isempty(Y));
    assert(isempty(I));
end

function test_inputs
    x = sparse(gemRand(3));
    
    % minimum 3 inputs
    shouldProduceAnError(@() min(x, 2, 3, 4));
    
    % second input should be empty if there is a third input
    shouldProduceAnError(@() min(x, 1, 1));

    % second input should be numeric
    shouldProduceAnError(@() min(x, 'all'));

    % second input should be of same size as the first one or a scalar
    shouldProduceAnError(@() min(x, [1 2]));

    % for an element-wise comparison, a single output is produced
    try
        [a b] = min(x, 1);
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
    assert(isa(min(sgem(-3), gem([1 2])), 'gem'));
    gemSparseLikeMatlab(1);
    assert(isa(min(sgem(-3), gem([1 2])), 'sgem'));
    
    gemSparseLikeMatlab(initStatus);
end
