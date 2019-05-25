function test_suite = ldivide_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    % element-wise division between two matrices
    y = generateDoubleMatrices(2, 5, {'F', 'FR', 'FI'});
    validateDoubleConsistency2(@(x,y) ldivide(x,y), y(1,:), y(2,:), 1e-5);
    validateDoubleConsistency2(@(x,y) ldivide(x,sparse(y)), y(1,:), y(2,:), 1e-5);
    validateDoubleConsistency2(@(x,y) ldivide(x,double(y)), y(1,:), y(2,:), 1e-5);
    validateDoubleConsistency2(@(x,y) ldivide(x,double(sparse(y))), y(1,:), y(2,:), 1e-5);
    validateDoubleConsistency2(@(x,y) ldivide(double(x),y), y(1,:), y(2,:), 1e-5);
    validateDoubleConsistency2(@(x,y) ldivide(double(sparse(x)),y), y(1,:), y(2,:), 1e-5);

    % division with a scalar
    validateDoubleConsistency2(@(x,y) ldivide(x,y(1)), y(1,:), y(2,:), 1e-5);
    validateDoubleConsistency2(@(x,y) ldivide(x,sparse(y(1))), y(1,:), y(2,:), 1e-5);
    validateDoubleConsistency2(@(x,y) ldivide(x,double(y(1))), y(1,:), y(2,:), 1e-5);
    validateDoubleConsistency2(@(x,y) ldivide(x,double(sparse(y(1)))), y(1,:), y(2,:), 1e-5);
    validateDoubleConsistency2(@(x,y) ldivide(double(x),y(1)), y(1,:), y(2,:), 1e-5);
    validateDoubleConsistency2(@(x,y) ldivide(double(sparse(x)),y(1)), y(1,:), y(2,:), 1e-5);

    validateDoubleConsistency2(@(x,y) ldivide(x(1),y), y(1,:), y(2,:), 1e-5);
    validateDoubleConsistency2(@(x,y) ldivide(x(1),sparse(y)), y(1,:), y(2,:), 1e-5);
    validateDoubleConsistency2(@(x,y) ldivide(x(1),double(y)), y(1,:), y(2,:), 1e-5);
    validateDoubleConsistency2(@(x,y) ldivide(x(1),double(sparse(y))), y(1,:), y(2,:), 1e-5);
    validateDoubleConsistency2(@(x,y) ldivide(double(x(1)),y), y(1,:), y(2,:), 1e-5);
    validateDoubleConsistency2(@(x,y) ldivide(double(sparse(x(1))),y), y(1,:), y(2,:), 1e-5);
end

function test_empty
    assert(isempty(gem([]).\gem([])));
end

function test_inputs
    x = gem.rand(3);
    
    % minimum and maximum 2 inputs
    shouldProduceAnError(@() ldivide(x));
    shouldProduceAnError(@() ldivide(x,x,x));
    
    % sizes should match
    shouldProduceAnError(@() ldivide(x, [1 2 3]));
end
