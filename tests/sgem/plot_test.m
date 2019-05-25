function test_suite = plot_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    % Octave may not have a graphic toolkit
    isOctave = exist('OCTAVE_VERSION', 'builtin') ~= 0;
    if ~isOctave
        plot(sgem([1 2]), sgem([1 2]));
    end
end
