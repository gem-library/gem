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
        x = {sgem(eye(15))};

        validateDoubleConsistency(@(x) svds(x), x, 1e-9, 1);
        validateDoubleConsistency(@(x) svds(x, 1), x, 1e-9, 1);
        validateDoubleConsistency(@(x) svds(x, min(2,size(x,1))), x, 1e-9, 1);

        % Octave has its own option naming convention
        assert( sum(abs(svds(x{1}, 2, 'largest') - svds(double(x{1}), 2, 'L'))) < 1e-9);
        assert( sum(abs(svds(x{1}, 2, 'smallest') - svds(double(x{1}), 2, 0))) < 1e-9);

        % For coverage monitoring purpose (this is tested by matlab)
        svds(x{1}, 14, 'smallest');
        [U S] = svds(x{1}, 5, 'smallest');
        [U S V] = svds(x{1}, 14, 'smallest');
        x = {gem(diag(ones(1,5),1) + diag(ones(1,4),-2))};
        svds(x{1}, 4);
        [U S V] = svds(x{1}, 4);
    else
        % Once in a while the eigenvalue decomposition can fail and that's ok -- for now
        testRun = false;
        while ~testRun
            try
                x = generateMatrices(2, 15, {'P', 'PR', 'PI', 'PQ', 'PQR', 'PQI', 'PS', 'PSR', 'PSI'});

                for i = 1:length(x)
                    if min(size(x{i})) >= 8
                        validateDoubleConsistency(@(x) svds(x), x(i), 1e-9, 1);
                        validateDoubleConsistency(@(x) svds(x, 3), x(i), 1e-9, 1);
                        validateDoubleConsistency(@(x) svds(x, 3), x(i), 1e-9, 1);
                        validateDoubleConsistency(@(x) svds(x, 3, 'largest'), x(i), 1e-9, 1);
                    end
                end

%                 % Currently there is a but in spectra which doesn't allow us to test for smallest eigenvalues...

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
    validateDoubleConsistency(@(x) svds(sparse(x), 1), x);
    validateDoubleConsistency(@(x) svds(sparse(x), 3), x);
    if isOctave
        assert( sum(abs(svds(sparse(x{1}), 2, 'smallest') - svds(double(sparse(x{1})), 2, 0))) < 1e-9);
    else
        validateDoubleConsistency(@(x) svds(sparse(x), 1, 'smallest'), x);
    end
end

function test_precision
    % Octave has trouble with its own eigs, so we go molo!
    isOctave = exist('OCTAVE_VERSION', 'builtin') ~= 0;
    
    if isOctave
        x = {sgem(eye(15))};

        targetPrecision = 10^(-(gemWorkingPrecision-10));
        for i = 1:length(x)
            S = svds(x{i});

            precision = double(abs(norm( S-1 , 1)));
            assert(precision < targetPrecision);
        end
    else
        % Once in a while the eigenvalue decomposition can fail and that's ok -- for now
        testRun = false;
        while ~testRun
            try
                x = generateMatrices(2, 15, {'PQR', 'PQR', 'PQI', 'PS', 'PSR', 'PSI'});

                targetPrecision = 10^(-(gemWorkingPrecision-10));
                for i = 1:length(x)
                    [U1 S1] = svds(x{i});
                    [U S V] = svds(x{i});

                    assert(norm(U1 - U) <= 1e-6);
                    assert(norm(S1 - S) <= 1e-6);

                    precision = double(abs(norm( S - U'*x{i}*V ,1)));
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
    [U S V] = svds(sgem([]));
    assert(isempty(U));
    assert(isempty(S));
    assert(isempty(V));
end

function test_inputs
    x = sparse(gemRand(2));
    
    % maximum 3 input supported
    shouldProduceAnError(@() svds(x, 1, 2, 2));
    
    % input 2 is a single positive number
    shouldProduceAnError(@() svds(x, [1 2]));
    shouldProduceAnError(@() svds(x, -1));
    shouldProduceAnError(@() svds(x, 4));
    [U S V] = svds(x, 0);
    assert(isempty(U));
    assert(isempty(S));
    assert(isempty(V));
    
    % input 3 cannot be arbitrary
    shouldProduceAnError(@() svds(x, 1, 'small'));
    shouldProduceAnError(@() svds(x, 1, [1 2]));
    
    % maximum 3 outputs supported
    shouldProduceAnError(@() svds(x), 4);
    
    % no eigenvectors computed for zero eigenvalues
    vect = gemRand(4,1);
    shouldProduceAnError(@() svds(sparse(vect*vect'), 2), 4);
    
    % no computation over an existing eigenvalue
    vect = gemRand(4,1);
    shouldProduceAnError(@() svds(sparse(vect*vect' + (vect+1)*(vect+1)'), 3, 'smallest'));

    % don't ask for all values if the matrix is too large
    shouldProduceAnError(@() svds(sparse(gemRand(30)), 29));
end
