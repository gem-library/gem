function test_suite = clean_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    x = generateMatrices(2, 5, {'A', 'AR', 'AI'});

    % Octave doesn't have the clean function
    isOctave = exist('OCTAVE_VERSION', 'builtin') ~= 0;
    if isOctave
        for i = 1:length(x)
            y = x{i}/250;
            yr = real(y);
            yi = imag(y);
            yr(find(abs(yr) < 0.01)) = 0;
            yi(find(abs(yi) < 0.01)) = 0;
            y = yr + yi*1i;
            assert(max(max(abs( clean(x{i}/250, 0.01) - y ))) < 1e-6);
        end
    else
        validateDoubleConsistency(@(x) clean(x/250, 0.01), x);
        validateDoubleConsistency(@(x) clean(double(x)/250, sgem(0.01)), x);
    end
    
    previousPrecision = gem.workingPrecision;
    gem.workingPrecision(2);
    assert(isequal(clean(sgem([0.005 0.015 0.03])), [0 0.015 0.03]));
    gem.workingPrecision(previousPrecision);
end


function test_inputs
    x = sparse(gem.rand(3));
    
    % tolerance must be a single positive number
    shouldProduceAnError(@() clean(x, '0.1'));
    shouldProduceAnError(@() clean(x, [1 2]));
    shouldProduceAnError(@() clean(x, -0.1));
end
