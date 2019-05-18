function test_suite = svds_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    
    % Octave has trouble with its own eigs, so we go molo!
    isOctave = exist('OCTAVE_VERSION', 'builtin') ~= 0;
    
    if isOctave
        x = {gem(eye(15))};

        validateDoubleConsistency(@(x) svds(x), x, 1e-9, 1);
        validateDoubleConsistency(@(x) svds(x, 1), x, 1e-9, 1);
        validateDoubleConsistency(@(x) svds(x, min(2,size(x,1))), x, 1e-9, 1);
        
        % Octave has its own option naming convention
        assert( abs(svds(x{1}, 2, 'largest') - svds(double(x{1}), 2, 'L')) < 1e-9);
        assert( abs(svds(x{1}, 2, 'smallest') - svds(double(x{1}), 2, 0)) < 1e-9);
    else
        % Once in a while the eigenvalue decomposition can fail and that's ok -- for now
        testRun = false;
        while ~testRun
            try
                x = generateMatrices(2, 5, {'F', 'FR', 'FI', 'FQ', 'FQR', 'FQI', 'FS', 'FSR', 'FSI'});

                validateDoubleConsistency(@(x) svds(x), x, 1e-9, 1);
                validateDoubleConsistency(@(x) svds(x, 1), x, 1e-9, 1);

                validateDoubleConsistency(@(x) svds(x, min(2,size(x,1))), x, 1e-9, 1);
                validateDoubleConsistency(@(x) svds(x, min(2,size(x,1)), 'largest'), x, 1e-9, 1);

%                 % Currently there is a but in spectra which doesn't allow us to test for smallest eigenvalues...
%                 for i = 1:length(x)
%                     if rank(x{i}) == size(x{i},1)
%                         validateDoubleConsistency(@(x) svds(x, min(2,size(x,1)), 'smallest'), x(i), 1e-9);
%                     end
%                 end

                testRun = true;
            catch me
                if ~isequal(me.message, 'Eigenvalue decomposition failed.')
                    assert(false);
                end
            end
        end
    end
    
    % We also check some low-rank matrices
    vect = gemRand(4,1)*10-5;
    x = {vect*vect', vect*vect' + (vect+1)*(vect+1)'};
    vect = gemRand(4,1)*10-5 + (gemRand(4,1)*10-5)*1i;
    x = cat(2, x, {vect*vect', vect*vect' + (vect+1)*(vect+1)'});
    vect = gemRand(14,1)*10-5;
    x = cat(2, x, {vect*vect', vect*vect' + (vect+1)*(vect+1)'});
    
    validateDoubleConsistency(@(x) svds(x, 1), x);
    validateDoubleConsistency(@(x) svds(x, 3), x);
    if isOctave
        assert( abs(svds(x{1}, 2, 'smallest') - svds(double(x{1}), 2, 0)) < 1e-9);
    else
        validateDoubleConsistency(@(x) svds(x, 1, 'smallest'), x);
    end
end

function test_precision

    % Octave has trouble with its own eigs, so we go molo!
    isOctave = exist('OCTAVE_VERSION', 'builtin') ~= 0;
    
    if isOctave
        x = {gem(eye(15))};

        targetPrecision = 10^(-(gemWorkingPrecision-10));
        for i = 1:length(x)
            [V D] = eigs(x{i});

            precision = double(abs(norm( V*D - x{i}*V ,1)));
            assert(precision < targetPrecision);
        end
    else
        % Once in a while the eigenvalue decomposition can fail and that's ok -- for now
        testRun = false;
        while ~testRun
            try
                x = generateMatrices(2, 5, {'FQ', 'FQR', 'FQI', 'FS', 'FSR', 'FSI'});

                targetPrecision = 10^(-(gemWorkingPrecision-10));
                for i = 1:length(x)
                    [V D] = eigs(x{i});

                    precision = double(abs(norm( V*D - x{i}*V ,1)));
                    assert(precision < targetPrecision);
                end

                testRun = true;
            catch me
                if ~isequal(me.message, 'Eigenvalue decomposition failed.')
                    assert(false);
                end
            end
        end
    end
end

function test_empty
    [U S V] = svds(gem([]));
    assert(isempty(U));
    assert(isempty(S));
    assert(isempty(V));
end

function test_inputs
    % maximum 3 input supported
    try
        svds(gemRand(2), 1, gemRand(1), gemRand(1));
        assert(false);
    catch
    end
    
    % input 2 is a single positive number
    try
        svds(gemRand(2), gemRand(1,2));
        assert(false);
    catch
    end
    try
        svds(gemRand(2), -1);
        assert(false);
    catch
    end
    try
        svds(gemRand(2), 4);
        assert(false);
    catch
    end
    [U S V] = svds(gemRand(2), 0);
    assert(isempty(U));
    assert(isempty(S));
    assert(isempty(V));
    
    % input 3 cannot be arbitrary
    try
        svds(gemRand(2), 1, 'small');
        assert(false);
    catch
    end
    try
        svds(gemRand(2), 1, [1 2]);
        assert(false);
    catch
    end
    
    % maximum 3 outputs supported
    try
        [U S V P] = svds(gemRand(2));
        assert(false);
    catch
    end
        
    % no eigenvectors computed for zero eigenvalues
    try
        vect = gemRand(4,1);
        [U S V] = svds(vect*vect', 2);
        assert(false);
    catch
    end
    
    % no computation over an existing eigenvalue
    try
        vect = gemRand(4,1);
        svds(vect*vect' + (vect+1)*(vect+1)', 3, 'smallest')
        assert(false);
    catch
    end
end
