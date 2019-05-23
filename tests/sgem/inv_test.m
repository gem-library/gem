function test_suite = inv_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    x = generateMatrices(2, 5, {'AQ', 'AQR', 'AQI'});
    validateDoubleConsistency(@(x) inv(x), x);
    
    validateDoubleConsistency(@(x) inv(x), {sgem([1 1; 1 1])});    
end

function test_empty
    assert(isempty(inv(sgem([]))))
end

function test_inputs
    % matrix must be square
    shouldProduceAnError(@() inv(sgem([1 2 3])));
end
