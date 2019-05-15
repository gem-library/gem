function test_suite = vertcat_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    y = generateMatrices(5, 4, {'A', 'AR', 'AI'});
    
    % cat with nothing
    validateDoubleConsistency(@(x,y) vertcat(x, []), y);
    validateDoubleConsistency(@(x,y) vertcat([], x), y);
    validateDoubleConsistency(@(x,y) vertcat(gem([]), x), y);

    % Generic test
    for i = 1:numel(y)-1
        for j = i+1:numel(y)
            if size(y{i}, 2) == size(y{j}, 2)
                validateDoubleConsistency2(@(x,y) vertcat(x, y), y(i), y(j));
                
                % We also test mixed cases
                validateDoubleConsistency2(@(x,y) vertcat(x, y), {double(y{i})}, y(j));
                validateDoubleConsistency2(@(x,y) vertcat(x, y), y(i), {double(y{j})});
                validateDoubleConsistency2(@(x,y) vertcat(x, y), {full(y{i})}, y(j));
                validateDoubleConsistency2(@(x,y) vertcat(x, y), y(i), {full(y{j})});
            end
            
            % Also test more than two inputs
            for k = j+1:numel(y)
                if (size(y{i}, 2) == size(y{j}, 2)) && (size(y{i}, 2) == size(y{k}, 2))
                    validateDoubleConsistency3(@(x,y,z) vertcat(x, y, z), y(i), y(j), y(k));
                end
            end
        end
    end
end

function test_inputs
    try
        vertcat(sgem([1 2]), sgem(2));
        assert(false);
    catch
    end
end
