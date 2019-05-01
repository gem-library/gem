function test_suite = test_rank()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    x = generateMatrices(2, 15, {'A', 'AR', 'AI', 'P', 'PR', 'PI'});
    
    % Matlab doesn't support rank for sparse matrices
    for i = 1:numel(x)
        assert(max(max(abs(rank(x{i})-rank(full(double(x{i})))))) <= 1e-9);
    end
end
