function test_suite = times_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    % element-wise multiplication between two matrices
    y = generateMatrices(2, 5, {'F', 'FR', 'FI'}, 2);
    validateDoubleConsistency2(@(x,y) times(x,y), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) times(x,sparse(y)), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) times(x,double(y)), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) times(x,double(sparse(y))), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) times(double(x),y), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) times(double(sparse(x)),y), y(1,:), y(2,:));

    % product with a scalar
    validateDoubleConsistency2(@(x,y) times(x,y(1)), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) times(x,sparse(y(1))), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) times(x,double(y(1))), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) times(x,double(sparse(y(1)))), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) times(double(x),y(1)), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) times(double(sparse(x)),y(1)), y(1,:), y(2,:));

    validateDoubleConsistency2(@(x,y) times(x(1),y), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) times(x(1),sparse(y)), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) times(x(1),double(y)), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) times(x(1),double(sparse(y))), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) times(double(x(1)),y), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) times(double(sparse(x(1))),y), y(1,:), y(2,:));

    % product with a vector
    validateDoubleConsistency2(@(x,y) times(x,y(1,:)), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) times(x,sparse(y(1,:))), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) times(x,double(y(1,:))), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) times(x,double(sparse(y(1,:)))), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) times(double(x),y(1,:)), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) times(double(sparse(x)),y(1,:)), y(1,:), y(2,:));

    validateDoubleConsistency2(@(x,y) times(x(1,:),y), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) times(x(1,:),sparse(y)), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) times(x(1,:),double(y)), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) times(x(1,:),double(sparse(y))), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) times(double(x(1,:)),y), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) times(double(sparse(x(1,:))),y), y(1,:), y(2,:));

    validateDoubleConsistency2(@(x,y) times(x,y(:,1)), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) times(x,sparse(y(:,1))), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) times(x,double(y(:,1))), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) times(x,double(sparse(y(:,1)))), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) times(double(x),y(:,1)), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) times(double(sparse(x)),y(:,1)), y(1,:), y(2,:));

    validateDoubleConsistency2(@(x,y) times(x(:,1),y), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) times(x(:,1),sparse(y)), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) times(x(:,1),double(y)), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) times(x(:,1),double(sparse(y))), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) times(double(x(:,1)),y), y(1,:), y(2,:));
    validateDoubleConsistency2(@(x,y) times(double(sparse(x(:,1))),y), y(1,:), y(2,:));
end

function test_empty
    assert(isempty(gem([]).*gem([])));
end

function test_inputs
    x = gem.rand(3);
    
    % minimum and maximum 2 inputs
    shouldProduceAnError(@() times(x));
    shouldProduceAnError(@() times(x,x,x));
    
    % sizes should match
    shouldProduceAnError(@() times(x, [1 2]));
end
