function test_suite = norm_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    x = generateMatrices(4, 5, {'F', 'FR', 'FI'});
    
    validateDoubleConsistency(@(x) norm(x), x);
    validateDoubleConsistency(@(x) norm(x, 1), x);
    validateDoubleConsistency(@(x) norm(x, 2), x);
    validateDoubleConsistency(@(x) norm(x, Inf), x);
    
    for i = 1:length(x)
        if min(size(x{i})) == 1
            validateDoubleConsistency(@(x) norm(x, 1.5), x(i));
            validateDoubleConsistency(@(x) norm(x, -Inf), x(i));
        else
            validateDoubleConsistency(@(x) norm(x, 'fro'), x(i));
        end
    end
end

function test_empty
    assert(norm(gem([]))==0);
end

function test_inputs
    % supported norms depend on the dimension
    shouldProduceAnError(@() norm(gem([1 2 3]), 'fro'));
    
    % norm must be a scalar
    shouldProduceAnError(@() norm(gem([1 2 3]), [1 2]));
    
    % third input cannot be anything
    shouldProduceAnError(@() norm(gem([1 2; 3 4]), -Inf));
end
