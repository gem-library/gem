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
        y = generateMatrices(15, 20, {'A', 'AR', 'AI'});

        % We also want to have at least one 'large' matrix
        y2 = generateMatrices(10, 20, {'A'});
        y2 = y2(find(cellfun(@(x) (size(x,1)>10)&&(size(x,2)>10), y2), 1, 'first'));
        y = cat(2, y, y2, y2);
    else
        y = generateMultipleMatrices(1, 20, {'A'}, 3);
        
        % We also want to have at least one 'large' matrix
        y2 = generateMatrices(10, 20, {'A'});
        y2 = y2(find(cellfun(@(x) (size(x,1)>10)&&(size(x,2)>10), y2), 1, 'first'));
        y = cat(2, y', y2, y2);
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
                validateDoubleConsistency2(@(x,y) vertcat(x, y), {full(y{i})}, y(j));
                validateDoubleConsistency2(@(x,y) vertcat(x, y), y(i), {full(y{j})});
                validateDoubleConsistency2(@(x,y) vertcat(x, y), {full(double(y{i}))}, y(j));
                validateDoubleConsistency2(@(x,y) vertcat(x, y), y(i), {full(double(y{j}))});
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
    shouldProduceAnError(@() vertcat(sgem([1 2]), sgem(2)));
end
