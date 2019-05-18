function test_suite = horzcat_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    y = generateMatrices(5, 4, {'F', 'FR', 'FI'});

    % cat with nothing
    validateDoubleConsistency(@(x,y) horzcat(x, []), y);
    validateDoubleConsistency(@(x,y) horzcat([], x), y);
    validateDoubleConsistency(@(x,y) horzcat(gem([]), x), y);

    % Generic case
    for i = 1:numel(y)-1
        for j = i+1:numel(y)
            if size(y{i}, 1) == size(y{j}, 1)
                validateDoubleConsistency2(@(x,y) horzcat(x, y), y(i), y(j));

                % We also test mixed cases
                validateDoubleConsistency2(@(x,y) horzcat(x, y), {double(y{i})}, y(j));
                validateDoubleConsistency2(@(x,y) horzcat(x, y), y(i), {double(y{j})});
                validateDoubleConsistency2(@(x,y) horzcat(x, y), {sparse(y{i})}, y(j));
                validateDoubleConsistency2(@(x,y) horzcat(x, y), y(i), {sparse(y{j})});
                validateDoubleConsistency2(@(x,y) horzcat(x, y), {sparse(double(y{i}))}, y(j));
                validateDoubleConsistency2(@(x,y) horzcat(x, y), y(i), {sparse(double(y{j}))});
            end
            
            % Also test more than two inputs
            for k = j+1:numel(y)
                if (size(y{i}, 1) == size(y{j}, 1)) && (size(y{i}, 1) == size(y{k}, 1))
                    validateDoubleConsistency3(@(x,y,z) horzcat(x, y, z), y(i), y(j), y(k));
                end
            end
        end
    end
end

function test_inputs
    shouldProduceAnError(@() horzcat(gem([1 2]'), gem(2)));
end
