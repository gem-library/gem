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
        y = generateDoubleMatrices(2, 5, {'A', 'AR', 'AI'});
    else
        y = generateDoubleMatrices(1, 5, {'A'});
    end
    validateDoubleConsistency2(@(x,y) rdivide(x,y), y(1,:), y(2,:), 1e-5);
    validateDoubleConsistency2(@(x,y) rdivide(x,full(y)), y(1,:), y(2,:), 1e-5);
    validateDoubleConsistency2(@(x,y) rdivide(x,double(y)), y(1,:), y(2,:), 1e-5);
    validateDoubleConsistency2(@(x,y) rdivide(x,double(full(y))), y(1,:), y(2,:), 1e-5);
    validateDoubleConsistency2(@(x,y) rdivide(double(x),y), y(1,:), y(2,:), 1e-5);
    validateDoubleConsistency2(@(x,y) rdivide(double(full(x)),y), y(1,:), y(2,:), 1e-5);

    % division with a scalar
    validateDoubleConsistency2(@(x,y) rdivide(x,y(1)), y(1,:), y(2,:), 1e-5);
    validateDoubleConsistency2(@(x,y) rdivide(x,full(y(1))), y(1,:), y(2,:), 1e-5);
    validateDoubleConsistency2(@(x,y) rdivide(x,double(y(1))), y(1,:), y(2,:), 1e-5);
    validateDoubleConsistency2(@(x,y) rdivide(x,double(full(y(1)))), y(1,:), y(2,:), 1e-5);
    validateDoubleConsistency2(@(x,y) rdivide(double(x),y(1)), y(1,:), y(2,:), 1e-5);
    validateDoubleConsistency2(@(x,y) rdivide(double(full(x)),y(1)), y(1,:), y(2,:), 1e-5);

    validateDoubleConsistency2(@(x,y) rdivide(x(1),y), y(1,:), y(2,:), 1e-5);
    validateDoubleConsistency2(@(x,y) rdivide(x(1),full(y)), y(1,:), y(2,:), 1e-5);
    validateDoubleConsistency2(@(x,y) rdivide(x(1),double(y)), y(1,:), y(2,:), 1e-5);
    validateDoubleConsistency2(@(x,y) rdivide(x(1),double(full(y))), y(1,:), y(2,:), 1e-5);
    validateDoubleConsistency2(@(x,y) rdivide(double(x(1)),y), y(1,:), y(2,:), 1e-5);
    validateDoubleConsistency2(@(x,y) rdivide(double(full(x(1))),y), y(1,:), y(2,:), 1e-5);
end

function test_empty
    assert(isempty(sgem([])./sgem([])));
end

function test_inputs
    x = sparse(gem.rand(3));
    
    % minimum and maximum 2 inputs
    shouldProduceAnError(@() rdivide(x));
    shouldProduceAnError(@() rdivide(x,x,x));
    
    % sizes should match
    shouldProduceAnError(@() rdivide(x, [1 2 3]));
end
