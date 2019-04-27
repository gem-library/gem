function test_suite = test_atan()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    x = generateMatrices(2, 5, {'F', 'FR', 'FI'});

    % Matlab has a definition of atan for some purely imaginary numbers
    % like 2.9i, which is different than standard math, we check the result
    % only up to a real constant of pi/2
    for i = 1:length(x)
        xi = x{i};
        yi = atan(xi);
        zi = atan(double(xi));
        for j = 1:numel(yi)
            assert( (max(abs(yi(j) - zi(j))) <= 1e-9) || (max(abs(yi(j) - zi(j) - pi)) <= 1e-9) || (max(abs(yi(j) - zi(j) + pi)) <= 1e-9) );
        end
    end
end
