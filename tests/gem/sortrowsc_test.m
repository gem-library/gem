function test_suite = sortrowsc_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    x = generateMatrices(2, 5, {'FR'});
    
    % Octave doesn't support sortrowsc
    isOctave = exist('OCTAVE_VERSION', 'builtin') ~= 0;
    if isOctave
        for i = 1:length(x)
            a = sortrowsc(x{i}, ones(1,size(x{i},2)));
            [b c] = sortrows(double(x{i}));
            assert(max(max(abs(a - c))) < 1e-5);

            a = sortrowsc(double(x{i}), -gem(ones(size(x{i},2),1)));
            [b c] = sortrows(double(x{i}), -[1:size(x{i},2)]);
            assert(max(max(abs(a - c))) < 1e-5);
        end
    else
        validateDoubleConsistency(@(x) sortrowsc(x, ones(1,size(x,2))), x);
        validateDoubleConsistency(@(x) sortrowsc(x, -ones(size(x,2),1)), x);
        validateDoubleConsistency(@(x) sortrowsc(double(x), gem(ones(1,size(x,2)))), x);
    end
end

function test_inputs
    % function takes two arguments
    shouldProduceAnError(@() sortrowsc(gem([1 2; 3 4])));
    
    % second argument must be of appropriate size
    shouldProduceAnError(@() sortrowsc(gem([1 2 3]), 1));

    % first input must be real
    shouldProduceAnError(@() sortrowsc(gem([1 2 3i]), [1 1 1]));
end
