function test_suite = power_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    % NOTE: Due to issue #4 we only check powers for positive numbers
    
    % element-wise power between two matrices
    y = generateDoubleMatrices(2, 5, {'A', 'AR', 'AI'});
    validateDoubleConsistency2(@(x,y) power(1+x./9,1+y/.9), y(1,:), y(2,:), 1e-3);
    validateDoubleConsistency2(@(x,y) power(1+x/.9,full(1+y/.9)), y(1,:), y(2,:), 1e-3);
    validateDoubleConsistency2(@(x,y) power(1+x/.9,double(1+y/.9)), y(1,:), y(2,:), 1e-3);
    validateDoubleConsistency2(@(x,y) power(1+x/.9,double(full(1+y/.9))), y(1,:), y(2,:), 1e-3);
    validateDoubleConsistency2(@(x,y) power(double(1+x/.9),1+y/.9), y(1,:), y(2,:), 1e-3);
    validateDoubleConsistency2(@(x,y) power(double(full(1+x/.9)),1+y/.9), y(1,:), y(2,:), 1e-3);

    % power with a scalar
    % Check if we are running octave: octave doesn't support power with a
    % scalar for either full or sparse objects
    isOctave = exist('OCTAVE_VERSION', 'builtin') ~= 0;
    if ~isOctave
        validateDoubleConsistency2(@(x,y) power(1+x/.9,1+y(1)/.9), y(1,:), y(2,:), 1e-3);
        validateDoubleConsistency2(@(x,y) power(1+x/.9,full(1+y(1)/.9)), y(1,:), y(2,:), 1e-3);
        validateDoubleConsistency2(@(x,y) power(1+x/.9,double(1+y(1)/.9)), y(1,:), y(2,:), 1e-3);
        validateDoubleConsistency2(@(x,y) power(1+x/.9,double(full(1+y(1)/.9))), y(1,:), y(2,:), 1e-3);
        validateDoubleConsistency2(@(x,y) power(double(1+x/.9),1+y(1)/.9), y(1,:), y(2,:), 1e-3);
        validateDoubleConsistency2(@(x,y) power(double(full(1+x/.9)),1+y(1)/.9), y(1,:), y(2,:), 1e-3);

        validateDoubleConsistency2(@(x,y) power(1+x(1)/.9,1+y/.9), y(1,:), y(2,:), 1e-3);
        validateDoubleConsistency2(@(x,y) power(1+x(1)/.9,full(1+y/.9)), y(1,:), y(2,:), 1e-3);
        validateDoubleConsistency2(@(x,y) power(1+x(1)/.9,double(1+y/.9)), y(1,:), y(2,:), 1e-3);
        validateDoubleConsistency2(@(x,y) power(1+x(1)/.9,double(full(1+y/.9))), y(1,:), y(2,:), 1e-3);
        validateDoubleConsistency2(@(x,y) power(double(1+x(1)/.9),1+y/.9), y(1,:), y(2,:), 1e-3);
        validateDoubleConsistency2(@(x,y) power(double(full(1+x(1)/.9)),1+y/.9), y(1,:), y(2,:), 1e-3);
    end
end

function test_empty
    assert(isempty(sgem([]).^sgem([])));
end

function test_inputs
    x = sparse(gemRand(3));
    
    % minimum and maximum 2 inputs
    shouldProduceAnError(@() power(x));
    shouldProduceAnError(@() power(x,x,x));
    
    % sizes should match
    shouldProduceAnError(@() power(x, [1 2 3]));
end
