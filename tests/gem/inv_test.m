function test_suite = inv_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    x = generateMatrices(2, 5, {'FQ', 'FQR', 'FQI'});
    validateDoubleConsistency(@(x) inv(x), x);
    
    validateDoubleConsistency(@(x) inv(x), {gem([1 1; 1 1])});    
end

function test_empty
    assert(isempty(inv(gem([]))))
end

function test_inputs
    % matrix must be square
    shouldProduceAnError(@() inv(gem([1 2 3])));
end
