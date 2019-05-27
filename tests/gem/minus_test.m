function test_suite = minus_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    % element-wise substraction between two matrices
    global fastTests
    if isempty(fastTests) || (fastTests == 0)
        y = generateMatrices(2, 5, {'F', 'FR', 'FI'}, 2);
    else
        y = generateMatrices(1, 5, {'F'}, 2);
    end
    validateDoubleConsistency2(@(x,y) minus(x,y), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) minus(x,sparse(y)), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) minus(x,double(y)), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) minus(x,double(sparse(y))), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) minus(double(x),y), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) minus(double(sparse(x)),y), y(1,:), y(2,:));

    % substraction with a scalar
    validateDoubleConsistency2(@(x,y) minus(x,y(1)), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) minus(x,sparse(y(1))), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) minus(x,double(y(1))), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) minus(x,double(sparse(y(1)))), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) minus(double(x),y(1)), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) minus(double(sparse(x)),y(1)), y(1,:), y(2,:));

    validateDoubleConsistency2(@(x,y) minus(x(1),y), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) minus(x(1),sparse(y)), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) minus(x(1),double(y)), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) minus(x(1),double(sparse(y))), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) minus(double(x(1)),y), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) minus(double(sparse(x(1))),y), y(1,:), y(2,:));
end

function test_empty
    assert(isempty(gem([])-gem([])));
end

function test_inputs
    x = gem.rand(3);
    
    % minimum and maximum 2 inputs
    shouldProduceAnError(@() minus(x));
    shouldProduceAnError(@() minus(x,x,x));
    
    % sizes should match
    shouldProduceAnError(@() minus(x, [1 2 3]));
end
