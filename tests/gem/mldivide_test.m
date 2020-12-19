function test_suite = mldivide_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    % division by a scalar is simple
    x = generateMatrices(2, 5, {'F', 'FR', 'FI'});
    r = rand;
    validateDoubleConsistency(@(x) mldivide(r, x), x, 1e-5);
    
    for i = 1:numel(x)
        for j = setdiff(1:numel(x),i)
            if (size(x{i},1) == size(x{j},1)) && (size(x{i},1) > size(x{i},2))
                validateDoubleConsistency2(@(x1, x2) mldivide(x1, x2), x(i), x(j), 1e-5);
            end
        end
    end
    
    % This should produce a warning because the matrix is almost singular
    command = 'mldivide(gem([1 0; 1 1e-47]), [1 0]'');';
    assert(~isempty(evalc(command)));
end

function test_precision
    % matrix division between two matrices
    global fastTests
    if isempty(fastTests) || (fastTests == 0)
        y = generateMatrices(2, 5, {'F', 'FR', 'FI'}, 2);
    else
        y = generateMatrices(1, 5, {'F'}, 2);
    end
    for i = 1:numel(y)
        for j = setdiff(1:numel(y),i)
            if (size(y{i},1) == size(y{j},1)) && (rank(y{i}) >= size(y{i},1))
                % In this case, the solution should match exactly
                z = mldivide(y{i}, y{j});
                assert(max(max(abs(y{i}*z - y{j}))) < 1e-5);

                z = mldivide(y{i}, sparse(y{j}));
                assert(max(max(abs(y{i}*z - y{j}))) < 1e-5);

                z = mldivide(y{i}, double(y{j}));
                assert(max(max(abs(y{i}*z - y{j}))) < 1e-5);

                z = mldivide(y{i}, double(sparse(y{j})));
                assert(max(max(abs(y{i}*z - y{j}))) < 1e-5);

                z = mldivide(double(y{i}), y{j});
                assert(max(max(abs(y{i}*z - y{j}))) < 1e-5);

                z = mldivide(double(sparse(y{i})), y{j});
                assert(max(max(abs(y{i}*z - y{j}))) < 1e-5);
            end
        end
    end
end

function test_empty
    assert(isempty(gem([])\gem([])));
end

function test_inputs
    x = gem.rand(3);
    
    % minimum and maximum 2 inputs
    shouldProduceAnError(@() mldivide(x));
    shouldProduceAnError(@() mldivide(x,x,x));
    
    % We can solve singular problems, in the sense of least squares
    evalc('mldivide(gem([1 0; 1 0]), [1 0]'')');

    % sizes should match
    shouldProduceAnError(@() mldivide(x, [1 2 3]));
end
