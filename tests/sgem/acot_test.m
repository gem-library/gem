function test_suite = acot_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    x = generateMatrices(2, 5, {'A', 'AR', 'AI'});

    % Matlab's implementation of atan is not consistent with doc (c.f.
    % test_atan.m), and this has consequences for acos. So we check the
    % result only up to a real constant of pi/2.
    for i = 1:length(x)
        xi = x{i};
        yi = acot(xi);
        zi = acot(double(xi));
        for j = 1:numel(yi)
            assert( (max(abs(yi(j) - zi(j))) <= 1e-9) || (max(abs(yi(j) - zi(j) - pi)) <= 1e-9) || (max(abs(yi(j) - zi(j) + pi)) <= 1e-9) );
        end
    end
end

function test_sparseLikeMatlab
    initStatus = gem.sparseLikeMatlab;
    
    gem.sparseLikeMatlab(0);
    assert(isa(acot(sgem(rand)), 'gem'));
    gem.sparseLikeMatlab(1);
    assert(isa(acot(sgem(rand)), 'sgem'));
    
    gem.sparseLikeMatlab(initStatus);
end
