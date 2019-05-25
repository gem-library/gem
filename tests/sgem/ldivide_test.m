function test_suite = ldivide_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    % element-wise division between two matrices
    y = generateDoubleMatrices(2, 5, {'A', 'AR', 'AI'});
    validateDoubleConsistency2(@(x,y) ldivide(x,y), y(1,:), y(2,:), 1e-5);
    validateDoubleConsistency2(@(x,y) ldivide(x,full(y)), y(1,:), y(2,:), 1e-5);
    validateDoubleConsistency2(@(x,y) ldivide(x,double(y)), y(1,:), y(2,:), 1e-5);
    validateDoubleConsistency2(@(x,y) ldivide(x,double(full(y))), y(1,:), y(2,:), 1e-5);
    validateDoubleConsistency2(@(x,y) ldivide(double(x),y), y(1,:), y(2,:), 1e-5);
    validateDoubleConsistency2(@(x,y) ldivide(double(full(x)),y), y(1,:), y(2,:), 1e-5);

    % division with a scalar
    validateDoubleConsistency2(@(x,y) ldivide(x,y(1)), y(1,:), y(2,:), 1e-5);
    validateDoubleConsistency2(@(x,y) ldivide(x,full(y(1))), y(1,:), y(2,:), 1e-5);
    validateDoubleConsistency2(@(x,y) ldivide(x,double(y(1))), y(1,:), y(2,:), 1e-5);
    validateDoubleConsistency2(@(x,y) ldivide(x,double(full(y(1)))), y(1,:), y(2,:), 1e-5);
    validateDoubleConsistency2(@(x,y) ldivide(double(x),y(1)), y(1,:), y(2,:), 1e-5);
    validateDoubleConsistency2(@(x,y) ldivide(double(full(x)),y(1)), y(1,:), y(2,:), 1e-5);

    validateDoubleConsistency2(@(x,y) ldivide(x(1),y), y(1,:), y(2,:), 1e-5);
    validateDoubleConsistency2(@(x,y) ldivide(x(1),full(y)), y(1,:), y(2,:), 1e-5);
    validateDoubleConsistency2(@(x,y) ldivide(x(1),double(y)), y(1,:), y(2,:), 1e-5);
    validateDoubleConsistency2(@(x,y) ldivide(x(1),double(full(y))), y(1,:), y(2,:), 1e-5);
    validateDoubleConsistency2(@(x,y) ldivide(double(x(1)),y), y(1,:), y(2,:), 1e-5);
    validateDoubleConsistency2(@(x,y) ldivide(double(full(x(1))),y), y(1,:), y(2,:), 1e-5);
end

function test_empty
    assert(isempty(sgem([]).\sgem([])));
end

function test_inputs
    x = sparse(gemRand(3));
    
    % minimum and maximum 2 inputs
    shouldProduceAnError(@() ldivide(x));
    shouldProduceAnError(@() ldivide(x,x,x));
    
    % sizes should match
    shouldProduceAnError(@() ldivide(x, [1 2 3]));
end
