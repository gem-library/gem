function test_suite = max_test()
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
    
    global fastTests
    if isempty(fastTests) || (fastTests == 0)
        x = generateMatrices(2, 5, {'P', 'PR', 'PI'});
    else
        x = generateMatrices(1, 5, {'P'});
    end
    
    validateDoubleConsistency(@(x) max(x), x);
    validateDoubleConsistency(@(x) max(x, [], 1), x);
    validateDoubleConsistency(@(x) max(x, [], 2), x);

    % element-wise maximum between two matrices
    if isempty(fastTests) || (fastTests == 0)
        y = generateMatrices(2, 5, {'P', 'PR', 'PI'}, 2);
    else
        y = generateMatrices(1, 5, {'P'}, 2);
    end
    validateDoubleConsistency2(@(x,y) max(x,y), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) max(x,full(y)), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) max(x,double(y)), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) max(x,double(full(y))), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) max(double(x),y), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) max(double(full(x)),y), y(1,:), y(2,:));

    % max with a scalar
    validateDoubleConsistency2(@(x,y) max(x,y(1)), y(1,:), y(2,:), 1e-12, 0, isOctave);
    validateDoubleConsistency2(@(x,y) max(x,0*y(1)), y(1,:), y(2,:), 1e-12, 0, isOctave);
    validateDoubleConsistency2(@(x,y) max(x,full(y(1))), y(1,:), y(2,:), 1e-12, 0, isOctave);
    validateDoubleConsistency2(@(x,y) max(x,double(y(1))), y(1,:), y(2,:), 1e-12, 0, isOctave);
    validateDoubleConsistency2(@(x,y) max(x,double(full(y(1)))), y(1,:), y(2,:), 1e-12, 0, isOctave);
    validateDoubleConsistency2(@(x,y) max(double(x),y(1)), y(1,:), y(2,:), 1e-12, 0, isOctave);
    validateDoubleConsistency2(@(x,y) max(double(full(x)),y(1)), y(1,:), y(2,:), 1e-12, 0, isOctave);

    validateDoubleConsistency2(@(x,y) max(x(1),y), y(1,:), y(2,:), 1e-12, 0, isOctave);
    validateDoubleConsistency2(@(x,y) max(0*x(1),y), y(1,:), y(2,:), 1e-12, 0, isOctave);
    validateDoubleConsistency2(@(x,y) max(x(1),full(y)), y(1,:), y(2,:), 1e-12, 0, isOctave);
    validateDoubleConsistency2(@(x,y) max(x(1),double(y)), y(1,:), y(2,:), 1e-12, 0, isOctave);
    validateDoubleConsistency2(@(x,y) max(x(1),double(full(y))), y(1,:), y(2,:), 1e-12, 0, isOctave);
    validateDoubleConsistency2(@(x,y) max(double(x(1)),y), y(1,:), y(2,:), 1e-12, 0, isOctave);
    validateDoubleConsistency2(@(x,y) max(double(full(x(1))),y), y(1,:), y(2,:), 1e-12, 0, isOctave);
    
    for i = 1:length(x)
        assert(abs(max(x{i}, [], 'all') - max(max(double(x{i})))) < 1e-5);
    end
end

function test_empty
    [Y I] = max(sgem([]));
    assert(isempty(Y));
    assert(isempty(I));
end

function test_inputs
    x = sparse(gem.rand(3));
    
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
    initStatus = gem.sparseLikeMatlab;
    
    gem.sparseLikeMatlab(0);
    assert(isa(max(sgem(3), gem([1 2])), 'gem'));
    gem.sparseLikeMatlab(1);
    assert(isa(max(sgem(3), gem([1 2])), 'sgem'));
    
    gem.sparseLikeMatlab(initStatus);
end
