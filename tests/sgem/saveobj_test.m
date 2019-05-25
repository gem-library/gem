function test_suite = saveobj_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_precision
    % Octave doesn't support saving classdef object (https://savannah.gnu.org/bugs/?45833)
    isOctave = exist('OCTAVE_VERSION', 'builtin') ~= 0;
    
    targetPrecision = 10.^(-gem.workingPrecision+10);
    if ~isOctave
        x = generateMatrices(2, 5, {'A', 'AR', 'AI'});
        y = x;
        
        save tmp x;
        clear x;
        load tmp;

        for i = 1:length(x)
            assert(max(max(abs(x{i}-y{i}))) < targetPrecision);
        end
    else
        x = sparse(gem.rand(3));
        y = x;
        
        stru = saveobj(x);
        save tmp stru;
        clear x stru
        load tmp;
        x = sgem.loadobj(stru);

        assert(max(max(abs(x-y))) < targetPrecision);
    end
end
