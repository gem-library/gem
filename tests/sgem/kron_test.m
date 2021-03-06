function test_suite = kron_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    % kronecker product of two matrices
    x = generateMatrices(1, 5, {'P', 'PR', 'PI'});
    for i = 1:numel(x)
        for j = 1:numel(x)
            validateDoubleConsistency2(@(x,y) kron(x,y), x(i), x(j));
            validateDoubleConsistency2(@(x,y) kron(x,full(y)), x(i), x(j));
            validateDoubleConsistency2(@(x,y) kron(x,double(y)), x(i), x(j));
            validateDoubleConsistency2(@(x,y) kron(x,double(full(y))), x(i), x(j));
            validateDoubleConsistency2(@(x,y) kron(double(x),y), x(i), x(j));
            validateDoubleConsistency2(@(x,y) kron(double(full(x)),y), x(i), x(j));
        end
    end
    
    % kronecker product of more matrices
    assert( max(max(abs( kron(x{1},x{2},x{3}) - kron(kron(double(x{1}), double(x{2})), double(x{3})) ))) < 1e-5 )
end

function test_empty
    assert(isempty(kron(sgem([]),sgem([]))));
end

function test_inputs
    x = sparse(gem.rand(3));
    
    % minimum and maximum 2 inputs
    shouldProduceAnError(@() kron(x));
end
