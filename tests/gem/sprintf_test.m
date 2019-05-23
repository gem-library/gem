function test_suite = sprintf_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    text = [' 3.141592653589793238462643383279502884197'; ' 2.718281828459045235360287471352662497757'];
    assert(isequal(sprintf('%42.40g', [gem('pi'); gem('e')]), text));

    % Octave doesn't linke printing imaginary numbers
    isOctave = exist('OCTAVE_VERSION', 'builtin') ~= 0;
    if isOctave
        x = generateMatrices(4, 5, {'FR'});
    else
        x = generateMatrices(4, 5, {'F', 'FR', 'FI'});
    end
    validateDoubleConsistency(@(x) sprintf('%d', x), x);
end

function test_empty
    assert(isempty(sprintf('%d', gem([]))));
end
