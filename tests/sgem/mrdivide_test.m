function test_suite = mrdivide_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_precision
    % matrix division between two matrices
    global fastTests
    if isempty(fastTests) || (fastTests == 0)
        y = generateMatrices(2, 5, {'P', 'PR', 'PI'}, 2);
    else
        y = generateMatrices(1, 5, {'P'}, 2);
    end
    for i = 1:numel(y)
        for j = setdiff(1:numel(y),i)
            if (size(y{i},2) == size(y{j},2)) && (rank(y{j}) >= size(y{j},2))
                z = mrdivide(y{i}, y{j});
                assert(max(max(abs(y{i} - z*y{j}))) < 1e-5);

                z = mrdivide(y{i}, full(y{j}));
                assert(max(max(abs(y{i} - z*y{j}))) < 1e-5);

                z = mrdivide(y{i}, double(y{j}));
                assert(max(max(abs(y{i} - z*y{j}))) < 1e-5);

                z = mrdivide(y{i}, double(full(y{j})));
                assert(max(max(abs(y{i} - z*y{j}))) < 1e-5);

                z = mrdivide(double(y{i}), y{j});
                assert(max(max(abs(y{i} - z*y{j}))) < 1e-5);

                z = mrdivide(double(full(y{i})), y{j});
                assert(max(max(abs(y{i} - z*y{j}))) < 1e-5);
            end
        end
    end
end

function test_empty
    assert(isempty(sgem([])/sgem([])));
end

function test_inputs
    x = sparse(gem.rand(3));
    
    % minimum and maximum 2 inputs
    shouldProduceAnError(@() mrdivide(x));
    shouldProduceAnError(@() mrdivide(x,x,x));
    
    % sizes don't need to match
    mrdivide(x, [1 2 3]);
end
