function test_suite = or_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    x = generateMatrices(2, 5, {'FR'});
    validateDoubleConsistency(@(x) or(x, x), x);
    
    % We generate another set of matrices with identical dimensions
    found = zeros(1,length(x));
    while ~all(found)
        y = generateMatrices(2, 5, {'FR'});
        for i = 1:length(y)
            if ~found(i) && isequal(size(x{i}),size(y{i}))
                z{i} = y{i};
                found(i) = 1;
            end
        end
    end
    
    validateDoubleConsistency2(@(x,y) or(x,y), x, z);
end
