function test_suite = cat_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    y = generateMatrices(5, 4, {'F', 'FR', 'FI'});
    for i = 1:numel(y)-1
        for j = i+1:numel(y)
            if size(y{i}, 2) == size(y{j}, 2)
                validateDoubleConsistency2(@(x,y) cat(1, x, y), y(i), y(j));
            end
            if size(y{i}, 1) == size(y{j}, 1)
                validateDoubleConsistency2(@(x,y) cat(2, x, y), y(i), y(j));
            end
            
            % Also test more than two inputs
            for k = j+1:numel(y)
                if (size(y{i}, 2) == size(y{j}, 2)) && (size(y{i}, 2) == size(y{k}, 2))
                    validateDoubleConsistency3(@(x,y,z) cat(1, x, y, z), y(i), y(j), y(k));
                end
                if (size(y{i}, 1) == size(y{j}, 1)) && (size(y{i}, 1) == size(y{k}, 1))
                    validateDoubleConsistency3(@(x,y,z) cat(2, x, y, z), y(i), y(j), y(k));
                end
            end
        end
    end
end

function test_inputs
    try
        cat(3, gem(1), gem(2));
        assert(false);
    catch
    end
end
