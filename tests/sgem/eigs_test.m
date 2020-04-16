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
        x = {sgem(eye(15))};

        validateDoubleConsistency(@(x) sort(abs(eigs(x))), x, 1e-9, 1);
        validateDoubleConsistency(@(x) abs(eigs(x, [], 1)), x, 1e-9, 1);
        validateDoubleConsistency(@(x) abs(eigs(x, [], min(2,size(x,1)))), x, 1e-9, 1);
        validateDoubleConsistency(@(x) abs(eigs(x, [], min(2,size(x,1)), 'lm')), x, 1e-9, 1);
        validateDoubleConsistency(@(x) abs(eigs(x, [], min(2,size(x,1)), 'sm')), x, 1e-9, 1);
        validateDoubleConsistency(@(x) abs(eigs(x, [], min(1,size(x,1)), 2)), x, 1e-9);
        
        % For coverage monitoring purpose (this is tested by matlab)
        eigs(x{1}, [], 14);
        eigs(x{1}, [], 14, 'sm');
        [V D] = eigs(x{1}, [], 14);
        [V D] = eigs(x{1}, [], 14, 'sm');
    else
        % Once in a while the eigenvalue decomposition can fail and that's ok -- for now
        testRun = false;
        while ~testRun
            try
                x = generateMatrices(2, 15, {'PQ', 'PQR', 'PQI', 'PS', 'PSR', 'PSI'});

                for i = 1:length(x)
                    if size(x{i},1) >= 8
                        validateDoubleConsistency(@(x) abs(eigs(x)), x(i), 1e-9, 1);
                        validateDoubleConsistency(@(x) abs(eigs(x, [], 3)), x(i), 1e-9, 1);
                        validateDoubleConsistency(@(x) abs(eigs(x, [], 3)), x(i), 1e-9, 1);
                        validateDoubleConsistency(@(x) abs(eigs(x, [], 3, 'lm')), x(i), 1e-9, 1);
                    end
                end

%                 % Currently there is a bug in spectra which doesn't allow us to test for smallest eigenvalues...

                testRun = true;
            catch me
                if ~isequal(me.message, 'Eigenvalue decomposition failed.')
                    assert(false);
                end
            end
        end
    end
    
    % null matrix
    validateDoubleConsistency(@(x) abs(eigs(x, [], 1)), {sgem(zeros(3))}, 1e-9);

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
    validateDoubleConsistency(@(x) sort(eigs(sparse(x), [], 1)), x);
    validateDoubleConsistency(@(x) sort(eigs(sparse(x), [], 3)), x);
    if isOctave
        % sometimes octave's algorithm diverges... so we just run them here
        % for coverage purpose (they are teste in matlab)
        for i = 1:length(x)
        	lambda = eigs(x{i}, [], 1, 'sm');
        end
    else
        validateDoubleConsistency(@(x) eigs(sparse(x), [], 1, 'sm'), x);
    end
end

function test_precision
    % Example potentially showing limited precision of the underlying
    % spectra library:
%     y = gem([                   0                                                0                                                0                                                0                                                0 - 1.9571298957191800000i                       0 + 1.3601478459577200000i                       0                                                0                         
%                                 0                                                0                                                0                                                0                                                0                                                0 - 1.0530066969243900000i                       0                                                0                         
%                                 0 + 0.1571233528648120000i                       0 + 1.8645377593657600000i                       0                                                0 - 1.6795707500435600000i                       0 + 0.4380678769984130000i                       0 + 0.5078963949214320000i                       0                                                0                         
%                                 0                                                0                                                0 + 1.6795707500435600000i                       0                                                0                                                0 + 0.8646936633167660000i                       0 - 3.3462656024352100000i                       0 + 2.1405658558947200000i
%                                 0                                                0 - 1.1431598927158500000i                       0                                                0 + 3.2350798209777100000i                       0                                                0                                                0                                                0                         
%                                 0                                                0                                                0                                                0                                                0                                                0                                                0                                                0                         
%                                 0                                                0 + 3.3559227473438700000i                       0                                                0 + 3.3462656024352100000i                       0 - 3.3187292336165900000i                       0 - 2.2472182658748800000i                       0                                                0                         
%                                 0                                                0                                                0                                                0 - 2.1405658558947200000i                       0                                                0                                                0                                                0                         ]);
%     [V D] = eigs(y);
%     precision = double(abs(norm( V*D - y*V ,1))); % ~3e-17

    % Octave has trouble with its own eigs, so we go molo!
    isOctave = exist('OCTAVE_VERSION', 'builtin') ~= 0;
    
    if isOctave
        x = {sgem(eye(15))};

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
                x = generateMatrices(2, 15, {'PQ', 'PQR', 'PQI', 'PS', 'PSR', 'PSI'});

                % Spectra sometimes stops at a precision of ~1e-15! So we don't check
                % this for now unfortunately with a very high precision,,,
                %targetPrecision = 10^(-(gem.workingPrecision-10));
                targetPrecision = 1e-9;
                for i = 1:length(x)
                    if size(x{i},1) >= 8
                        [V D] = eigs(x{i});

                        precision = double(abs(norm( V*D - x{i}*V ,1)));
                        assert(precision < targetPrecision);
                    end
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
    [V D] = eigs(sgem([]));
    assert(isempty(V));
    assert(isempty(D));
end

function test_inputs
    x = sparse(gem.rand(2));
    
    % maximum 4 input supported
    shouldProduceAnError(@() eigs(x, [], 1, 2, 2));
    
    % input 2 must be empty
    shouldProduceAnError(@() eigs(x, 2));
    
    % input 3 is a single positive number
    shouldProduceAnError(@() eigs(x, [], [1 2]));
    shouldProduceAnError(@() eigs(x, [], -1));
    shouldProduceAnError(@() eigs(x, [], 4));
    [V D] = eigs(x, [], 0);
    assert(isempty(V));
    assert(isempty(D));
    
    % input 4 cannot be arbitrary
    shouldProduceAnError(@() eigs(x, [], 1, 'small'));
    shouldProduceAnError(@() eigs(x, [], 1, [1 2]));
    
    % maximum 2 outputs supported
    shouldProduceAnError(@() eigs(x), 3);
    
    % input matrix must be squares
    shouldProduceAnError(@() eigs(sparse(gem.rand(2,3))));
    shouldProduceAnError(@() eigs(sparse(gem.rand(20,30))));
    
    % no eigenvectors computed for zero eigenvalues
    vect = gem.rand(4,1);
    shouldProduceAnError(@() eigs(sparse(vect*vect'), [], 2), 2);
    vect = gem.rand(4,1);
    shouldProduceAnError(@() eigs(sparse(vect*vect'), [], 1, 'sm'), 2);
    
    % no computation over an existing eigenvalue
    vect = gem.rand(4,1);
    shouldProduceAnError(@() eigs(sparse(vect*vect' + (vect+1)*(vect+1)'), [], 3, 0));
end
