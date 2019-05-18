function test_suite = eig_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    x = generateMatrices(2, 5, {'FQ', 'FQR', 'FQI', 'FS', 'FSR', 'FSI'});
    validateDoubleConsistency(@(x) sort(abs(eig(x))), x);
end

function test_precision
    x = generateMatrices(2, 5, {'FQ', 'FQR', 'FQI', 'FS', 'FSR', 'FSI'});
    
    targetPrecision = 10^(-(gemWorkingPrecision-10));
    for i = 1:length(x)
        [V D] = eig(x{i});
        
        precision = double(abs(norm( V*D*inv(V) - x{i} ,1)));
        assert(precision < targetPrecision);
    end
end

function test_empty
    [V D] = eig(gem([]));
    assert(isempty(V));
    assert(isempty(D));
end

function test_inputs
    % maximum 1 input supported
    shouldProduceAnError(@() eig(gemRand(2), gemRand(2)));
    
    % maximum 2 outputs supported
    shouldProduceAnError(@() eig(gemRand(2)), 3);
    
    % input matrix must be squares
    shouldProduceAnError(@() eig(gemRand(2,3)));
end
