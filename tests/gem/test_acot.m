function test_suite = test_acot()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    x = generateMatrices(2, 5, {'F', 'FR', 'FI'});

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

