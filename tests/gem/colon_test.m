function test_suite = colon_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    % We test a few cases
    x = generateMatrices(6, 3, {'FR'});
    for i = 1:numel(x)-1
        if x{i}(1) <= x{i+1}(1)
            validateDoubleConsistency2(@(x,y) colon(x,y), x(i), x(i+1));
            validateDoubleConsistency2(@(x,y) colon(x,y), x(i), {double(x{i+1})});
            validateDoubleConsistency2(@(x,y) colon(x,y), {double(x{i})}, x(i+1));
        end
    end
    for i = 1:numel(x)-2
        if sign(x{i+2}(1) - x{i}(1)) == sign(x{i+1}(1))
            validateDoubleConsistency3(@(x,y,z) colon(x,y,z), x(i), x(i+1), x(i+2));
            validateDoubleConsistency3(@(x,y,z) colon(x,y,z), x(i), x(i+1), {double(x{i+2})});
            validateDoubleConsistency3(@(x,y,z) colon(x,y,z), x(i), {double(x{i+1})}, x(i+2));
            validateDoubleConsistency3(@(x,y,z) colon(x,y,z), {double(x{i})}, x(i+1), x(i+2));
        end
    end
end

function test_empty
    assert(isempty(gem(2):gem(1)));
    assert(isempty(gem(2):1:gem(1)));
    assert(isempty(gem(1):-1:gem(2)));
end
