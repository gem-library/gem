function test_suite = plus_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    % element-wise addition between two matrices
    y = generateDoubleMatrices(2, 5, {'F', 'FR', 'FI'});
    validateDoubleConsistency2(@(x,y) plus(x,y), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) plus(x,sparse(y)), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) plus(x,double(y)), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) plus(x,double(sparse(y))), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) plus(double(x),y), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) plus(double(sparse(x)),y), y(1,:), y(2,:));

    % addition with a scalar
    validateDoubleConsistency2(@(x,y) plus(x,y(1)), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) plus(x,sparse(y(1))), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) plus(x,double(y(1))), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) plus(x,double(sparse(y(1)))), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) plus(double(x),y(1)), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) plus(double(sparse(x)),y(1)), y(1,:), y(2,:));

    validateDoubleConsistency2(@(x,y) plus(x(1),y), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) plus(x(1),sparse(y)), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) plus(x(1),double(y)), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) plus(x(1),double(sparse(y))), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) plus(double(x(1)),y), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) plus(double(sparse(x(1))),y), y(1,:), y(2,:));
end

function test_empty
    assert(isempty(gem([])+gem([])));
end

function test_inputs
    x = gem.rand(3);
    
    % minimum and maximum 2 inputs
    shouldProduceAnError(@() plus(x));
    shouldProduceAnError(@() plus(x,x,x));
    
    % sizes should match
    shouldProduceAnError(@() plus(x, [1 2 3]));
end
