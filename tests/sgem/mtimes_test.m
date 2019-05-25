function test_suite = mtimes_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    y = generateDoubleMatrices(2, 5, {'P', 'PR', 'PI'});
    for i = 1:numel(y)
        for j = setdiff(1:numel(y),i)
            if size(y{i},2) == size(y{j},1)
                % matrix multiplication between two matrices
                validateDoubleConsistency2(@(x,y) mtimes(x,y), y(i), y(j));
                validateDoubleConsistency2(@(x,y) mtimes(x,full(y)), y(i), y(j));
                validateDoubleConsistency2(@(x,y) mtimes(x,double(y)), y(i), y(j));
                validateDoubleConsistency2(@(x,y) mtimes(x,double(full(y))), y(i), y(j));
                validateDoubleConsistency2(@(x,y) mtimes(double(x),y), y(i), y(j));
                validateDoubleConsistency2(@(x,y) mtimes(double(full(x)),y), y(i), y(j));

                % multiplication with a scalar
                validateDoubleConsistency2(@(x,y) mtimes(x,y(1)), y(i), y(j));
                validateDoubleConsistency2(@(x,y) mtimes(x,full(y(1))), y(i), y(j));
                validateDoubleConsistency2(@(x,y) mtimes(x,double(y(1))), y(i), y(j));
                validateDoubleConsistency2(@(x,y) mtimes(x,double(full(y(1)))), y(i), y(j));
                validateDoubleConsistency2(@(x,y) mtimes(double(x),y(1)), y(i), y(j));
                validateDoubleConsistency2(@(x,y) mtimes(double(full(x)),y(1)), y(i), y(j));

                validateDoubleConsistency2(@(x,y) mtimes(x(1),y), y(i), y(j));
                validateDoubleConsistency2(@(x,y) mtimes(x(1),full(y)), y(i), y(j));
                validateDoubleConsistency2(@(x,y) mtimes(x(1),double(y)), y(i), y(j));
                validateDoubleConsistency2(@(x,y) mtimes(x(1),double(full(y))), y(i), y(j));
                validateDoubleConsistency2(@(x,y) mtimes(double(x(1)),y), y(i), y(j));
                validateDoubleConsistency2(@(x,y) mtimes(double(full(x(1))),y), y(i), y(j));
            end
        end
    end
end

function test_empty
    assert(isempty(sgem([])*sgem([])));
end

function test_inputs
    x = sparse(gemRand(3));
    
    % minimum and maximum 2 inputs
    shouldProduceAnError(@() mtimes(x));
    shouldProduceAnError(@() mtimes(x,x,x));
    
    % sizes should match
    shouldProduceAnError(@() mtimes(x, [1 2 3]));
end
