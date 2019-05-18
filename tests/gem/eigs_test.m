function test_suite = eigs_test()
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

        validateDoubleConsistency(@(x) sort(abs(eigs(x))), x, 1e-9, 1);
        validateDoubleConsistency(@(x) abs(eigs(x, [], 1)), x, 1e-9, 1);
        validateDoubleConsistency(@(x) abs(eigs(x, [], min(2,size(x,1)))), x, 1e-9, 1);
        validateDoubleConsistency(@(x) abs(eigs(x, [], min(2,size(x,1)), 'lm')), x, 1e-9, 1);
        validateDoubleConsistency(@(x) abs(eigs(x, [], min(2,size(x,1)), 'sm')), x, 1e-9, 1);
        validateDoubleConsistency(@(x) abs(eigs(x, [], min(1,size(x,1)), 2)), x, 1e-9);
        
        % For coverage monitoring purpose (this is tested by matlab)
        eigs(x{1}, [], 15, 'sm');
        [V D] = eigs(x{1}, [], 15, 'sm');
        x = {gem(diag(ones(1,5),1) + diag(ones(1,4),-2))};
        eigs(x{1}, [], 6);
        [V D] = eigs(x{1}, [], 6);
    else
        % Once in a while the eigenvalue decomposition can fail and that's ok -- for now
        testRun = false;
        while ~testRun
            try
                x = generateMatrices(2, 5, {'FQ', 'FQR', 'FQI', 'FS', 'FSR'});%, 'FSI'});

                validateDoubleConsistency(@(x) sort(abs(eigs(x))), x, 1e-9, 1);
                validateDoubleConsistency(@(x) abs(eigs(x, [], 1)), x, 1e-9, 1);

                validateDoubleConsistency(@(x) abs(eigs(x, [], min(2,size(x,1)))), x, 1e-9, 1);
                validateDoubleConsistency(@(x) abs(eigs(x, [], min(2,size(x,1)), 'lm')), x, 1e-9, 1);

%                 % Currently there is a but in spectra which doesn't allow us to test for smallest eigenvalues...
%                 for i = 1:length(x)
%                     if rank(x{i}) == size(x{i},1)
%                         validateDoubleConsistency(@(x) abs(eigs(x, [], min(2,size(x,1)), 'sm')), x(i), 1e-9);
%                     end
%                 end
%                 validateDoubleConsistency(@(x) abs(eigs(x, [], min(1,size(x,1)), 1)), x, 1e-9);

                testRun = true;
            catch me
                if ~isequal(me.message, 'Eigenvalue decomposition failed.')
                    assert(false);
                end
            end
        end
    end
    
    % null matrix
    validateDoubleConsistency(@(x) abs(eigs(x, [], 1)), {gem(zeros(3))}, 1e-9);

    % We also check some low-rank matrices
    vect = gemRand(5,1)*10-5;
    x = {vect*vect', vect*vect' + (vect+1)*(vect+1)'};
    if ~isOctave
        vect = gemRand(5,1)*10-5 + (gemRand(5,1)*10-5)*1i;
        x = cat(2, x, {vect*vect', vect*vect' + (vect+1)*(vect+1)'});
    end
    vect = gemRand(14,1)*10-5;
    x = cat(2, x, {vect*vect', vect*vect' + (vect+1)*(vect+1)'});

    % warning: octave doesn't sort out eigenvalues when all don't
    % converge...
    validateDoubleConsistency(@(x) sort(eigs(x, [], 1)), x);
    validateDoubleConsistency(@(x) sort(eigs(x, [], 3)), x);
    if isOctave
        % sometimes octave's algorithm diverges... so we just run them here
        % for coverage purpose (they are teste in matlab)
        for i = 1:length(x)
        	lambda = eigs(x{i}, [], 1, 'sm');
        end
    else
        validateDoubleConsistency(@(x) eigs(sparse(x), [], 1, 'sm'), x);
    end

    x = {gem([1 1 1]'*[1 1 1])};
    assert(abs(eigs(x{1},[],1,gem(1.9)) - eigs(double(x{1}),[],1,1.9)) < 1e-6);
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
                x = generateMatrices(2, 5, {'FQ', 'FQR', 'FQI', 'FS', 'FSR'});%, 'FSI'});

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
    [V D] = eigs(gem([]));
    assert(isempty(V));
    assert(isempty(D));
end

function test_inputs
    % maximum 3 input supported
    try
        eigs(gemRand(2), [], 1, gemRand(1), gemRand(1));
        assert(false);
    catch
    end
    
    % input 2 must be empty
    try
        eigs(gemRand(2), gemRand(1));
        assert(false);
    catch
    end
    
    % input 3 is a single positive number
    try
        eigs(gemRand(2), [], gemRand(1,2));
        assert(false);
    catch
    end
    try
        eigs(gemRand(2), [], -1);
        assert(false);
    catch
    end
    try
        eigs(gemRand(2), [], 4);
        assert(false);
    catch
    end
    [V D] = eigs(gemRand(2), [], 0);
    assert(isempty(V));
    assert(isempty(D));
    
    % input 4 cannot be arbitrary
    try
        eigs(gemRand(2), [], 1, 'small');
        assert(false);
    catch
    end
    try
        eigs(gemRand(2), [], 1, [1 2]);
        assert(false);
    catch
    end
    
    % maximum 2 outputs supported
    try
        [V D W] = eigs(gemRand(2));
        assert(false);
    catch
    end
    
    % input matrix must be squares
    try
        eigs(gemRand(2,3));
        assert(false);
    catch
    end
    try
        eigs(gemRand(20,30));
        assert(false);
    catch
    end
    
    % no eigenvectors computed for zero eigenvalues
    try
        vect = gemRand(4,1);
        [V D] = eigs(vect*vect', [], 2);
        assert(false);
    catch
    end
    try
        vect = gemRand(4,1);
        [V D] = eigs(vect*vect', [], 1, 'sm');
        assert(false);
    catch
    end

    % no computation over an existing eigenvalue
    try
        vect = gemRand(4,1);
        eigs(vect*vect' + (vect+1)*(vect+1)', [], 3, 0)
        assert(false);
    catch
    end
end
