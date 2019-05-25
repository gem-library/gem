function test_suite = plus_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    % element-wise addition between two matrices
    y = generateDoubleMatrices(2, 5, {'A', 'AR', 'AI'});
    validateDoubleConsistency2(@(x,y) plus(x,y), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) plus(x,full(y)), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) plus(x,double(y)), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) plus(x,double(full(y))), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) plus(double(x),y), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) plus(double(full(x)),y), y(1,:), y(2,:));

    % addition with a scalar
    validateDoubleConsistency2(@(x,y) plus(x,y(1)), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) plus(x,full(y(1))), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) plus(x,double(y(1))), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) plus(x,double(full(y(1)))), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) plus(double(x),y(1)), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) plus(double(full(x)),y(1)), y(1,:), y(2,:));

    validateDoubleConsistency2(@(x,y) plus(x(1),y), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) plus(x(1),full(y)), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) plus(x(1),double(y)), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) plus(x(1),double(full(y))), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) plus(double(x(1)),y), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) plus(double(full(x(1))),y), y(1,:), y(2,:));
end

function test_empty
    assert(isempty(sgem([])+sgem([])));
end

function test_sparseLikeMatlab
    initStatus = gemSparseLikeMatlab;
    
    gemSparseLikeMatlab(0);
    assert(isa(plus(sgem([0 1 2]), sgem(3)), 'gem'));
    gemSparseLikeMatlab(1);
    assert(isa(plus(sgem([0 1 2]), sgem(3)), 'sgem'));
    
    gemSparseLikeMatlab(initStatus);
end

function test_inputs
    x = sparse(gemRand(3));
    
    % minimum and maximum 2 inputs
    shouldProduceAnError(@() plus(x));
    shouldProduceAnError(@() plus(x,x,x));
    
    % sizes should match
    shouldProduceAnError(@() plus(x, [1 2 3]));
end
