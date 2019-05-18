function test_suite = subsref_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    x = generateMatrices(2, 15, {'F', 'FR', 'FI'});
    
    validateDoubleConsistency(@(x) x([]), x);
    validateDoubleConsistency(@(x) x(1), x);
    validateDoubleConsistency(@(x) x(1,1), x);
    validateDoubleConsistency(@(x) x(1:end), x);
    validateDoubleConsistency(@(x) x(1:end), x);
    validateDoubleConsistency(@(x) x([true false]), x);

    x = {gemRand(300,300)};
    validateDoubleConsistency(@(x) x(1:end-1,1:end-1), x);
    x = {gemRand(50010,1)};
    validateDoubleConsistency(@(x) x(1:end-1,:), x);
    x = {gemRand(1,50010)};
    validateDoubleConsistency(@(x) x(:,1:end-1), x);
end

function test_inputs
    x = gemRand(3);
    
    % maximum 2 dimensions
    try
        x(1,2,3);
        assert(false);
    catch
    end
    
    % minimum and maximum indices
    try
        x(0);
        assert(false);
    catch
    end
    try
        x(1,0);
        assert(false);
    catch
    end
    try
        x(20);
        assert(false);
    catch
    end
    try
        x(1:4,1:4);
        assert(false);
    catch
    end
    
    % index is numeric
    try
        x('1');
        assert(false);
    catch
    end
    
    % we cannot access protected properties
    try
        x.objectIdentifier;
        assert(false);
    catch
    end
    
    % we cannot create an object of more than 2 dimensions
    try
        x(cat(3,[1 2; 1 2], [2 3; 2 3]));
        assert(false);
    catch
    end
    try
        x(1,cat(3,[1 2; 1 2], [2 3; 2 3]));
        assert(false);
    catch
    end
end
