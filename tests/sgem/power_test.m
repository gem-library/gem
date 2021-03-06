function test_suite = power_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    global fastTests
    if isempty(fastTests) || (fastTests == 0)
        y = generateMatrices(2, 5, {'A', 'AR', 'AI'}, 2);
    else
        y = generateMatrices(1, 5, {'A'}, 2);
    end

    % element-wise power between two matrices
    validateDoubleConsistency2(@(x,y) power(x,y), y(1,:), y(2,:), 1e-3);
    validateDoubleConsistency2(@(x,y) power(x,full(y)), y(1,:), y(2,:), 1e-3);
    validateDoubleConsistency2(@(x,y) power(x,double(y)), y(1,:), y(2,:), 1e-3);
    validateDoubleConsistency2(@(x,y) power(x,double(full(y))), y(1,:), y(2,:), 1e-3);
    validateDoubleConsistency2(@(x,y) power(double(x),y), y(1,:), y(2,:), 1e-3);
    validateDoubleConsistency2(@(x,y) power(double(full(x)),y), y(1,:), y(2,:), 1e-3);

    % power with a scalar
    % Check if we are running octave: octave doesn't support power with a
    % scalar for either full or sparse objects
    isOctave = exist('OCTAVE_VERSION', 'builtin') ~= 0;
    if ~isOctave
        validateDoubleConsistency2(@(x,y) power(x,y(1)), y(1,:), y(2,:), 1e-3);
        validateDoubleConsistency2(@(x,y) power(x,full(y(1))), y(1,:), y(2,:), 1e-3);
        validateDoubleConsistency2(@(x,y) power(x,double(y(1))), y(1,:), y(2,:), 1e-3);
        validateDoubleConsistency2(@(x,y) power(x,double(full(y(1)))), y(1,:), y(2,:), 1e-3);
        validateDoubleConsistency2(@(x,y) power(double(x),y(1)), y(1,:), y(2,:), 1e-3);
        validateDoubleConsistency2(@(x,y) power(double(full(x)),y(1)), y(1,:), y(2,:), 1e-3);

        validateDoubleConsistency2(@(x,y) power(x(1),y), y(1,:), y(2,:), 1e-3);
        validateDoubleConsistency2(@(x,y) power(x(1),full(y)), y(1,:), y(2,:), 1e-3);
        validateDoubleConsistency2(@(x,y) power(x(1),double(y)), y(1,:), y(2,:), 1e-3);
        validateDoubleConsistency2(@(x,y) power(x(1),double(full(y))), y(1,:), y(2,:), 1e-3);
        validateDoubleConsistency2(@(x,y) power(double(x(1)),y), y(1,:), y(2,:), 1e-3);
        validateDoubleConsistency2(@(x,y) power(double(full(x(1))),y), y(1,:), y(2,:), 1e-3);
    end
end

function test_empty
    assert(isempty(sgem([]).^sgem([])));
end

function test_inputs
    x = sparse(gem.rand(3));
    
    % minimum and maximum 2 inputs
    shouldProduceAnError(@() power(x));
    shouldProduceAnError(@() power(x,x,x));
    
    % sizes should match
    shouldProduceAnError(@() power(x, [1 2 3]));
end
