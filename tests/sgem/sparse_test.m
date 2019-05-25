function test_suite = sparse_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_precision
    x = gem.rand(3);
    [I J V] = find(x);
    s = size(x);
    
    targetPrecision = 10.^(-gem.workingPrecision+10);
    
    I = sgem(I);
    assert(max(max(abs(sparse(I,J,V) - x))) < targetPrecision);
    assert(max(max(abs(sparse(I,J,V,s(1),s(2)) - x))) < targetPrecision);
    
    assert(isequal(size(sparse(sgem(4),5)), [4 5]));
end

function test_inputs
    shouldProduceAnError(@() sparse(sgem(1), 1, 1, 1));
end
