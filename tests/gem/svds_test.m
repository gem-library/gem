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
        validateDoubleConsistency(@(x) svds(x, gem(1)), x, 1e-9, 1);
        validateDoubleConsistency(@(x) svds(x, min([2, size(x)])), x, 1e-9, 1);
        
        % Octave has its own option naming convention
        assert( sum(abs(svds(x{1}, 2, 'largest') - svds(double(x{1}), 2, 'L'))) < 1e-9);
        assert( sum(abs(svds(x{1}, 2, 'smallest') - svds(double(x{1}), 2, 0))) < 1e-9);
        
        % For coverage monitoring purpose (this is tested by matlab)
        svds(x{1}, 15, 'smallest');
        [U S] = svds(x{1}, 5, 'smallest');
        [U S V] = svds(x{1}, 5, 'smallest');
        [U S V] = svds(x{1}, 15, 'smallest');
        x = {gem(diag(ones(1,5),1) + diag(ones(1,4),-2))};
        svds(x{1}, 5);
        [U S V] = svds(x{1}, 5);
    else
        % Once in a while the eigenvalue decomposition can fail and that's ok -- for now
        testRun = false;
        while ~testRun
            try
                x = generateMatrices(2, 5, {'F', 'FR', 'FI', 'FQ', 'FQR', 'FQI', 'FS', 'FSR', 'FSI'});

                validateDoubleConsistency(@(x) svds(x), x, 1e-9, 1);
                validateDoubleConsistency(@(x) svds(x, gem(1)), x, 1e-9, 1);
                validateDoubleConsistency(@(x) svds(x, min([2, size(x)])), x, 1e-9, 1);
                validateDoubleConsistency(@(x) svds(x, min([2, size(x)]), 'largest'), x, 1e-9, 1);

%                 % Currently there is a bug in spectra which doesn't allow us to test for smallest eigenvalues...
%                 for i = 1:length(x)
%                     if rank(x{i}) == size(x{i},1)
%                         validateDoubleConsistency(@(x) svds(x, min([2, size(x)]), 'smallest'), x(i), 1e-9);
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
    vect = gem.rand(4,1)*10-5;
    x = {vect*vect', vect*vect' + (vect+1)*(vect+1)'};
    vect = gem.rand(4,1)*10-5 + (gem.rand(4,1)*10-5)*1i;
    x = cat(2, x, {vect*vect', vect*vect' + (vect+1)*(vect+1)'});
    vect = gem.rand(14,1)*10-5;
    x = cat(2, x, {vect*vect', vect*vect' + (vect+1)*(vect+1)'});
    
    validateDoubleConsistency(@(x) svds(x, 1), x, 1e-10, 1);
    validateDoubleConsistency(@(x) svds(x, 3), x, 1e-10, 1);
    if isOctave
        assert( sum(abs(svds(x{1}, 2, 'smallest') - svds(double(x{1}), 2, 0))) < 1e-9);
    else
        validateDoubleConsistency(@(x) svds(x, 1, 'smallest'), x);
    end
end

function test_precision

    % Octave has trouble with its own eigs, so we go molo!
    isOctave = exist('OCTAVE_VERSION', 'builtin') ~= 0;
    
    if isOctave
        % NOTE: Due to issue #3, we only check whether the singular values
        %       are identical for a matrix with degenerate eigenvalues
        x = {gem(eye(15))};

        targetPrecision = 10^(-(gem.workingPrecision-10));
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
                % NOTE: Due to issue #3 we don't check imaginary symmetric
                %       matrices
                x = generateMatrices(2, 5, {'FQ', 'FQR', 'FQI', 'FS', 'FSR'});%, 'FSI'});

                targetPrecision = 10^(-(gem.workingPrecision-10));
                for i = 1:length(x)
                    [U1 S1] = svds(x{i}, 1);
                    [U S V] = svds(x{i}, 1);

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
    [U S V] = svds(gem([]));
    assert(isempty(U));
    assert(isempty(S));
    assert(isempty(V));
end

function test_inputs
    % maximum 3 input supported
    shouldProduceAnError(@() svds(gem.rand(2), 1, gem.rand(1), gem.rand(1)));
    
    % input 2 is a single positive number
    shouldProduceAnError(@() svds(gem.rand(2), gem.rand(1,2)));
    shouldProduceAnError(@() svds(gem.rand(2), -1));
    shouldProduceAnError(@() svds(gem.rand(2), 4));
    [U S V] = svds(gem.rand(2), 0);
    assert(isempty(U));
    assert(isempty(S));
    assert(isempty(V));
    
    % input 3 cannot be arbitrary
    shouldProduceAnError(@() svds(gem.rand(2), 1, 'small'));
    shouldProduceAnError(@() svds(gem.rand(2), 1, [1 2]));
    
    % no eigenvectors computed for zero eigenvalues
    vect = gem.rand(4,1);
    [a b c] = svds(vect*vect', 2);
    
    % computation over an existing eigenvalue is ok
    vect = gem.rand(4,1);
    svds(vect*vect' + (vect+1)*(vect+1)', 3, 'smallest');
end
