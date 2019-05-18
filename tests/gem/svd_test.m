function test_suite = svd_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    x = generateMatrices(2, 5, {'F', 'FR', 'FI', 'FQ', 'FQR', 'FQI', 'FS', 'FSR', 'FSI'});
    validateDoubleConsistency(@(x) svd(x), x);
end

function test_precision
    % NOTE: For now we don't deal (c.f. github issue #3)
    x = generateMatrices(2, 5, {'F', 'FR', 'FI', 'FQ', 'FQR', 'FQI', 'FS', 'FSR'});%, 'FSI'});
    
    targetPrecision = 10^(-(gemWorkingPrecision-10));
    for i = 1:length(x)
        [U S V] = svd(x{i}, 'econ');
        
        precision = double(abs(norm( U*S*V' - x{i} ,1)));
        assert(precision < targetPrecision);
    end
end

function test_empty
    [V D] = svd(gem([]), 'econ');
    assert(isempty(V));
    assert(isempty(D));
end

function test_inputs
    % maximum 2 input supported
    try
        svd(gemRand(2), 'econ', gemRand(2));
        assert(false);
    catch
    end
    
    % input 1 cannot be anything
    try
        svd(gemRand(2), 'economic');
        assert(false);
    catch
    end
    
    % maximum 2 outputs supported
    try
        [S V D P] = svd(gemRand(2));
        assert(false);
    catch
    end
end
