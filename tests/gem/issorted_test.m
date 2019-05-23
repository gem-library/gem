function test_suite = issorted_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    x = generateMatrices(2, 5, {'F', 'FR', 'FI'});
    for i = 1:length(x)
        if min(size(x{i})) == 1
            validateDoubleConsistency(@(x) issorted(x), x(i));
        else
            % Matrix sorting is currently not supported due to issue #6
%            validateDoubleConsistency(@(x) issorted(x, 'rows'), x(i));
        end
    end
end

function test_inputs
    % matrix must be checked with an option
    shouldProduceAnError(@() issorted(gem([1 2; 3 4])));

    % the options for matrices must be 'rows'
%    shouldProduceAnError(@() issorted(gem([1 2; 3 4]), 'cols'));
end
