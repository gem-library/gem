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
        eigs(x{1}, [], 5);
        [V D] = eigs(x{1}, [], 5);
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
    vect = gem.rand(5,1)*10-5;
    x = {vect*vect', vect*vect' + (vect+1)*(vect+1)'};
    if ~isOctave
        vect = gem.rand(5,1)*10-5 + (gem.rand(5,1)*10-5)*1i;
        x = cat(2, x, {vect*vect', vect*vect' + (vect+1)*(vect+1)'});
    end
    vect = gem.rand(14,1)*10-5;
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

        targetPrecision = 10^(-(gem.workingPrecision-10));
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
                x = generateMatrices(2, 15, {'FQ', 'FQR', 'FQI', 'FS', 'FSR', 'FSI'});

                targetPrecision = 10^(-(gem.workingPrecision-10));
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
    shouldProduceAnError(@() eigs(gem.rand(2), [], 1, gem.rand(1), gem.rand(1)));
    
    % input 2 must be empty
    shouldProduceAnError(@() eigs(gem.rand(2), gem.rand(1)));
    
    % input 3 is a single positive number
    shouldProduceAnError(@() eigs(gem.rand(2), [], gem.rand(1,2)));
    shouldProduceAnError(@() eigs(gem.rand(2), [], -1));
    shouldProduceAnError(@() eigs(gem.rand(2), [], 4));
    [V D] = eigs(gem.rand(2), [], 0);
    assert(isempty(V));
    assert(isempty(D));
    
    % input 4 cannot be arbitrary
    shouldProduceAnError(@() eigs(gem.rand(2), [], 1, 'small'));
    shouldProduceAnError(@() eigs(gem.rand(2), [], 1, [1 2]));
    
    % maximum 2 outputs supported
    shouldProduceAnError(@() eigs(gem.rand(2)), 3);
    
    % input matrix must be squares
    shouldProduceAnError(@() eigs(gem.rand(2,3)));
    shouldProduceAnError(@() eigs(gem.rand(20,30)));
    
    % no eigenvectors computed for zero eigenvalues
    vect = gem.rand(4,1);
    shouldProduceAnError(@() eigs(vect*vect', [], 2), 2);
    vect = gem.rand(4,1);
    shouldProduceAnError(@() eigs(vect*vect', [], 1, 'sm'), 2);

    % no computation over an existing eigenvalue
    vect = gem.rand(4,1);
    shouldProduceAnError(@() eigs(vect*vect' + (vect+1)*(vect+1)', [], 3, 0));
end
