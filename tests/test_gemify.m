function test_suite = test_gemify()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_full
    x = rand(10,10);
    y = gemify(x);
    assert(isa(y, 'gem'));
end

function test_sparse
    x = sparse(rand(10,10));
    y = gemify(x);
    assert(isa(y, 'sgem'));
end
