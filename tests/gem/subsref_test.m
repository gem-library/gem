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
    shouldProduceAnError(@() x(1,2,3));
    
    % minimum and maximum indices
    shouldProduceAnError(@() x(0));
    shouldProduceAnError(@() x(1,0));
    shouldProduceAnError(@() x(20));
    shouldProduceAnError(@() x(1:4,1:4));
    
    % index is numeric
    shouldProduceAnError(@() x('1'));
    
    % we cannot access protected properties
    shouldProduceAnError(@() x.objectIdentifier);
    
    % we cannot create an object of more than 2 dimensions
    shouldProduceAnError(@() x(cat(3,[1 2; 1 2], [2 3; 2 3])));
    shouldProduceAnError(@() x(1,cat(3,[1 2; 1 2], [2 3; 2 3])));
end
