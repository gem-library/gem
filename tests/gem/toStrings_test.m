function test_suite = toStrings_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    text = {'3.141592653589793238462643383279502884197169399375101', '2.718281828'};
    disp(toStrings(gem('pi')));
    disp(toStrings(gem('e'),10));
    assert(isequal(toStrings(gem('pi')), text{1}));
    assert(isequal(toStrings(gem('e'),10), text{2}));
end

function test_empty
    assert(isempty(toStrings(gem([]))));
end
