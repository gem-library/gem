function test_suite = toStrings_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    % warning, we don't check really all digits, because different
    % implementations can slightly make a difference
    text = {'3.1415926535897932384626433832795028841971693993', '2.718281828'};
    fullString = toStrings(gem('pi'));
    assert(isequal(fullString(1:48), text{1}));
    assert(isequal(toStrings(gem('e'),10), text{2}));
end

function test_empty
    assert(isempty(toStrings(gem([]))));
end
