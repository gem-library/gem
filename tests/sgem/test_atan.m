function test_suite = test_atan()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    x = generateMatrices(2, 5, {'A', 'AR', 'AI'});

    % Matlab's atan does not always correspond to the definition given in
    % the documentation. For instance, for 
    %   y = gem('0 - 4.73831774784872769851661197176195485070522742666383i')
    %   z = double(y)
    % matlab's function says that 
    %   atan(z) = 1.5708 - 0.2143i
    % but the definition given in the doc gives
    %   1i/2*log((1i+z)/(1i-z)) = -1.5708 - 0.2143i
    % So we check the result only up to a real constant of pi/2
    for i = 1:length(x)
        xi = x{i};
        yi = atan(xi);
        zi = atan(double(xi));
        for j = 1:numel(yi)
            assert( (max(abs(yi(j) - zi(j))) <= 1e-9) || (max(abs(yi(j) - zi(j) - pi)) <= 1e-9) || (max(abs(yi(j) - zi(j) + pi)) <= 1e-9) );
        end
    end
end
