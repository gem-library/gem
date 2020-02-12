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
    
    targetPrecision = 10^(-(gem.workingPrecision-10));
    for i = 1:length(x)
        [V D] = eig(x{i});
        
        precision = double(abs(norm( V*D - x{i}*V ,1)));
        assert(precision < targetPrecision);
    end
    
    % Let's test more cases with degenerate subspaces
    isOctave = exist('OCTAVE_VERSION', 'builtin') ~= 0;
    if ~isOctave
        x = generateMatrices(2, 10, {'FQ', 'FQR', 'FQI', 'FS', 'FSR', 'FSI'});

        targetPrecision = 10^(-(gem.workingPrecision-10));
        for i = 1:length(x)
            [V D] = eig(x{i});

            precision = double(abs(norm( V*D - x{i}*V ,1)));
            assert(precision < targetPrecision);
            
            d = diag(D);
            which = ceil(length(d)*rand(1,length(d)));
            y = V*diag(d(which))*inv(V);
            
            % At the moment, we don't support non-hermitian complex
            % matrices with degenerate eigenvalues. This is bug #14
            if isreal(y) || ishermitian(y)
                [V D] = eig(y);

                precision = double(abs(norm( V*D - y*V ,1)));
                assert(precision < targetPrecision);
            end
        end
    end
end

function test_empty
    [V D] = eig(gem([]));
    assert(isempty(V));
    assert(isempty(D));
end

function test_inputs
    % maximum 1 input supported
    shouldProduceAnError(@() eig(gem.rand(2), gem.rand(2)));
    
    % maximum 2 outputs supported
    shouldProduceAnError(@() eig(gem.rand(2)), 3);
    
    % input matrix must be squares
    shouldProduceAnError(@() eig(gem.rand(2,3)));
end
