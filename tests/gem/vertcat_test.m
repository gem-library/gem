function test_suite = vertcat_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    global fastTests
    if isempty(fastTests) || (fastTests == 0)
        y = generateMatrices(5, 4, {'F', 'FR', 'FI'});
    else
        y = generateMultipleMatrices(1, 4, {'F'}, 3);
    end
    
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
                validateDoubleConsistency2(@(x,y) vertcat(x, y), {sparse(y{i})}, y(j));
                validateDoubleConsistency2(@(x,y) vertcat(x, y), y(i), {sparse(y{j})});
                validateDoubleConsistency2(@(x,y) vertcat(x, y), {sparse(double(y{i}))}, y(j));
                validateDoubleConsistency2(@(x,y) vertcat(x, y), y(i), {sparse(double(y{j}))});
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
    shouldProduceAnError(@() vertcat(gem([1 2]), gem(2)));
end
