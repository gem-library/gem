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
        y = generateDoubleMatrices(2, 5, {'A', 'AR', 'AI'});
    else
        y = generateDoubleMatrices(1, 5, {'A'});
    end
    validateDoubleConsistency2(@(x,y) minus(x,y), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) minus(x,full(y)), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) minus(x,double(y)), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) minus(x,double(full(y))), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) minus(double(x),y), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) minus(double(full(x)),y), y(1,:), y(2,:));

    % substraction with a scalar
    validateDoubleConsistency2(@(x,y) minus(x,y(1)), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) minus(x,full(y(1))), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) minus(x,double(y(1))), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) minus(x,double(full(y(1)))), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) minus(double(x),y(1)), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) minus(double(full(x)),y(1)), y(1,:), y(2,:));

    validateDoubleConsistency2(@(x,y) minus(x(1),y), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) minus(x(1),full(y)), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) minus(x(1),double(y)), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) minus(x(1),double(full(y))), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) minus(double(x(1)),y), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) minus(double(full(x(1))),y), y(1,:), y(2,:));
end

function test_empty
    assert(isempty(sgem([])-sgem([])));
end

function test_sparseLikeMatlab
    initStatus = gem.sparseLikeMatlab;
    
    gem.sparseLikeMatlab(0);
    assert(isa(minus(sgem([0 1 2]), sgem(3)), 'gem'));
    gem.sparseLikeMatlab(1);
    assert(isa(minus(sgem([0 1 2]), sgem(3)), 'sgem'));
    
    gem.sparseLikeMatlab(initStatus);
end

function test_inputs
    x = sparse(gem.rand(3));
    
    % minimum and maximum 2 inputs
    shouldProduceAnError(@() minus(x));
    shouldProduceAnError(@() minus(x,x,x));
    
    % sizes should match
    shouldProduceAnError(@() minus(x, [1 2 3]));
end
