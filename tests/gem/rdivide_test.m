function test_suite = rdivide_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    % element-wise division between two matrices
    global fastTests
    if isempty(fastTests) || (fastTests == 0)
        y = generateMatrices(2, 5, {'F', 'FR', 'FI'}, 2);
    else
        y = generateMatrices(1, 5, {'F'}, 2);
    end
    validateDoubleConsistency2(@(x,y) rdivide(x,y), y(1,:), y(2,:), 1e-5);
    validateDoubleConsistency2(@(x,y) rdivide(x,sparse(y)), y(1,:), y(2,:), 1e-5);
    validateDoubleConsistency2(@(x,y) rdivide(x,double(y)), y(1,:), y(2,:), 1e-5);
    validateDoubleConsistency2(@(x,y) rdivide(x,double(sparse(y))), y(1,:), y(2,:), 1e-5);
    validateDoubleConsistency2(@(x,y) rdivide(double(x),y), y(1,:), y(2,:), 1e-5);
    validateDoubleConsistency2(@(x,y) rdivide(double(sparse(x)),y), y(1,:), y(2,:), 1e-5);

    % division with a scalar
    validateDoubleConsistency2(@(x,y) rdivide(x,y(1)), y(1,:), y(2,:), 1e-5);
    validateDoubleConsistency2(@(x,y) rdivide(x,sparse(y(1))), y(1,:), y(2,:), 1e-5);
    validateDoubleConsistency2(@(x,y) rdivide(x,double(y(1))), y(1,:), y(2,:), 1e-5);
    validateDoubleConsistency2(@(x,y) rdivide(x,double(sparse(y(1)))), y(1,:), y(2,:), 1e-5);
    validateDoubleConsistency2(@(x,y) rdivide(double(x),y(1)), y(1,:), y(2,:), 1e-5);
    validateDoubleConsistency2(@(x,y) rdivide(double(sparse(x)),y(1)), y(1,:), y(2,:), 1e-5);

    validateDoubleConsistency2(@(x,y) rdivide(x(1),y), y(1,:), y(2,:), 1e-5);
    validateDoubleConsistency2(@(x,y) rdivide(x(1),sparse(y)), y(1,:), y(2,:), 1e-5);
    validateDoubleConsistency2(@(x,y) rdivide(x(1),double(y)), y(1,:), y(2,:), 1e-5);
    validateDoubleConsistency2(@(x,y) rdivide(x(1),double(sparse(y))), y(1,:), y(2,:), 1e-5);
    validateDoubleConsistency2(@(x,y) rdivide(double(x(1)),y), y(1,:), y(2,:), 1e-5);
    validateDoubleConsistency2(@(x,y) rdivide(double(sparse(x(1))),y), y(1,:), y(2,:), 1e-5);
end

function test_empty
    assert(isempty(gem([])./gem([])));
end

function test_inputs
    x = gem.rand(3);
    
    % minimum and maximum 2 inputs
    shouldProduceAnError(@() rdivide(x));
    shouldProduceAnError(@() rdivide(x,x,x));
    
    % sizes should match
    shouldProduceAnError(@() rdivide(x, [1 2 3]));
end
