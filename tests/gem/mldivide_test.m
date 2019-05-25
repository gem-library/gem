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
    
    % This should produce a warning because the matrix is almost singular
    mldivide(gem([1 0; 1 1e-47]), [1 0]');
end

function test_precision
    % matrix division between two matrices
    y = generateDoubleMatrices(2, 5, {'F', 'FR', 'FI'});
    for i = 1:numel(y)
        for j = setdiff(1:numel(y),i)
            if (size(y{i},1) == size(y{j},1)) && (rank(y{i}) >= size(y{i},1))
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
    
    % We cannot solve singular problems
    shouldProduceAnError(@() mldivide(gem([1 0; 1 0]), [1 0]'));

    % sizes should match
    shouldProduceAnError(@() mldivide(x, [1 2 3]));
end
