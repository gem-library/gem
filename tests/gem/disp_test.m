function test_suite = disp_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    x = generateMatrices(2, 5, {'F', 'FR', 'FI'});
    
    for i = 1:numel(x)
        disp(x{i});
        disp(x{i}, 4);
        disp(x{i}, -1);
        disp(x{i}, gem(4));
    end
end
