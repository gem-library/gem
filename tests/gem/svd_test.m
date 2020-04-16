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
    validateDoubleConsistency(@(x) svd(x, 0), x);
    validateDoubleConsistency(@(x) svd(x, 'econ'), x);
end

function test_precision
    x = generateMatrices(2, 5, {'F', 'FR', 'FI', 'FQ', 'FQR', 'FQI', 'FS', 'FSR', 'FSI'});
    
    targetPrecision = 10^(-(gem.workingPrecision-10));
    for i = 1:length(x)
        [U S V] = svd(x{i});
        precision = double(abs(norm( U*S - x{i}*V ,1)));
        assert(precision < targetPrecision);

        [U S V] = svd(x{i}, 0);
        precision = double(abs(norm( U*S - x{i}*V ,1)));
        assert(precision < targetPrecision);

        [U S V] = svd(x{i}, 'econ');
        precision = double(abs(norm( U*S - x{i}*V ,1)));
        assert(precision < targetPrecision);
    end
    
    % Let's test more cases with degenerate subspaces
    isOctave = exist('OCTAVE_VERSION', 'builtin') ~= 0;
    if ~isOctave
        x = generateMatrices(2, 10, {'F', 'FR', 'FI', 'FQ', 'FQR', 'FQI', 'FS', 'FSR', 'FSI'});

        targetPrecision = 10^(-(gem.workingPrecision-10));
        for i = 1:length(x)
            [U S V] = svd(x{i});
            precision = double(abs(norm( U*S - x{i}*V ,1)));
            assert(precision < targetPrecision);
            
            [U S V] = svd(x{i}, 0);
            precision = double(abs(norm( U*S - x{i}*V ,1)));
            assert(precision < targetPrecision);

            [U S V] = svd(x{i}, 'econ');
            precision = double(abs(norm( U*S - x{i}*V ,1)));
            assert(precision < targetPrecision);

            d = diag(S);
            which = ceil(length(d)*rand(1,length(d)));
            y = U*diag(d(which))*V';
            
            [U S V] = svd(y);
            precision = double(abs(norm( U*S - y*V ,1)));
            assert(precision < targetPrecision);

            [U S V] = svd(y, 0);
            precision = double(abs(norm( U*S - y*V ,1)));
            assert(precision < targetPrecision);

            [U S V] = svd(y, 'econ');
            precision = double(abs(norm( U*S - y*V ,1)));
            assert(precision < targetPrecision);
        end
    end    
end

function test_empty
    [V D] = svd(gem([]), 'econ');
    assert(isempty(V));
    assert(isempty(D));
end

function test_inputs
    % maximum 2 input supported
    shouldProduceAnError(@() svd(gem.rand(2), 'econ', gem.rand(2)));
    
    % input 1 cannot be anything
    shouldProduceAnError(@() svd(gem.rand(2), 'economic'));
end
