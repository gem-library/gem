function test_suite = times_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    % element-wise multiplication between two matrices
    y = generateMatrices(2, 5, {'P', 'PR', 'PI'}, 2);
    validateDoubleConsistency2(@(x,y) times(x,y), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) times(x,full(y)), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) times(x,double(y)), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) times(x,double(full(y))), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) times(double(x),y), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) times(double(full(x)),y), y(1,:), y(2,:));

    % product with a scalar
    validateDoubleConsistency2(@(x,y) times(x,y(1)), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) times(x,full(y(1))), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) times(x,double(y(1))), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) times(x,double(full(y(1)))), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) times(double(x),y(1)), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) times(double(full(x)),y(1)), y(1,:), y(2,:));

    validateDoubleConsistency2(@(x,y) times(x(1),y), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) times(x(1),full(y)), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) times(x(1),double(y)), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) times(x(1),double(full(y))), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) times(double(x(1)),y), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) times(double(full(x(1))),y), y(1,:), y(2,:));
end

function test_empty
    assert(isempty(sgem([]).*sgem([])));
end

function test_inputs
    x = sparse(gem.rand(3));
    
    % minimum and maximum 2 inputs
    shouldProduceAnError(@() times(x));
    shouldProduceAnError(@() times(x,x,x));
    
    % sizes should match
    shouldProduceAnError(@() times(x, [1 2 3]));
end
