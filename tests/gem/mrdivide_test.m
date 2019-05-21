function test_suite = mrdivide_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_precision
    % NOTE : Due to issue #5, we don't test sparse matrices yet
    
    % matrix division between two matrices
    y = generateDoubleMatrices(2, 5, {'F', 'FR', 'FI'});
    for i = 1:numel(y)
        for j = setdiff(1:numel(y),i)
            if (size(y{i},2) == size(y{j},2)) && (rank(y{j}) >= size(y{j},2))
                z = mrdivide(y{i}, y{j});
                assert(max(max(abs(y{i} - z*y{j}))) < 1e-5);

%                 z = mrdivide(y{i}, sparse(y{j}));
%                 assert(max(max(abs(y{i} - z*y{j}))) < 1e-5);

                z = mrdivide(y{i}, double(y{j}));
                assert(max(max(abs(y{i} - z*y{j}))) < 1e-5);

%                 z = mrdivide(y{i}, double(sparse(y{j})));
%                 assert(max(max(abs(y{i} - z*y{j}))) < 1e-5);

                z = mrdivide(double(y{i}), y{j});
                assert(max(max(abs(y{i} - z*y{j}))) < 1e-5);

%                 z = mrdivide(double(sparse(y{i})), y{j});
%                 assert(max(max(abs(y{i} - z*y{j}))) < 1e-5;
            end
        end
    end
end

function test_empty
    assert(isempty(gem([])/gem([])));
end

function test_inputs
    x = gemRand(3);
    
    % minimum and maximum 2 inputs
    shouldProduceAnError(@() mrdivide(x));
    shouldProduceAnError(@() mrdivide(x,x,x));
    
    % sizes should match
    shouldProduceAnError(@() mrdivide(x, [1 2 3]));
end
