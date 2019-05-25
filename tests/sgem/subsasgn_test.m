function test_suite = subsasgn_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    x = generateMatrices(2, 15, {'A', 'AR', 'AI'});
    
    for i = 1:length(x)
        y = x{i};
        z = double(y);
        
        y(1) = 1;
        z(1) = 1;
        assert(abs(max(max(y-z))) <= 1e-6);
        
        y([true false]) = 1;
        z([true false]) = 1;
        assert(abs(max(max(y-z))) <= 1e-6);
        
        y(:,1) = 1;
        z(:,1) = 1;
        assert(abs(max(max(y-z))) <= 1e-6);
        
        y(:) = 1;
        z(:) = 1;
        assert(abs(max(max(y-z))) <= 1e-6);

        y([]) = 3;
        z([]) = 3;
        assert(abs(max(max(y-z))) <= 1e-6);

        y(1:2,1:2) = 1;
        z(1:2,1:2) = 1;
        assert(abs(max(max(y-z))) <= 1e-6);
        
        y(1:end-1,1) = 1;
        z(1:end-1,1) = 1;
        assert(abs(max(max(y-z))) <= 1e-6);
        
        y([1 2], 1:end-1) = 1;
        z([1 2], 1:end-1) = 1;
        assert(abs(max(max(y-z))) <= 1e-6);
        
        y(1:2, [1 2]) = 1;
        z(1:2, [1 2]) = 1;
        assert(abs(max(max(y-z))) <= 1e-6);
        
        y([1 2], 1) = [1 2]';
        z([1 2], 1) = [1 2]';
        assert(abs(max(max(y-z))) <= 1e-6);
        
        y(1, [1 2]) = [1 2];
        z(1, [1 2]) = [1 2];
        assert(abs(max(max(y-z))) <= 1e-6);
        
        y(1, [1 2 3 4]) = [1 2 3 4]';
        z(1, [1 2 3 4]) = [1 2 3 4]';
        assert(abs(max(max(y-z))) <= 1e-6);
    end
    
    x = sgem([]);
    x(1:3) = 2;

    x = sgem([]);
    x(1,1:3) = 2;
    x(5) = 2;

    x = sgem([]);
    x(1:3,1) = 2;
    x(4) = 4;
    x = x';
    x(5) = 5;
    x(6:7) = [6 7];
end

function test_inputs
    x = sparse(gem.rand(3));
    
    % maximum 2 dimensions
    try
        x(1,2,3) = sgem(1);
        error('The error test failed')
    catch me
        if isequal(me.message, 'The error test failed')
            assert(false);
        end
    end
    
    % only parentheses
    try
        x.t = sgem(1);
        error('The error test failed')
    catch me
        if isequal(me.message, 'The error test failed')
            assert(false);
        end
    end
    try
        x{1} = sgem(1);
        error('The error test failed')
    catch me
        if isequal(me.message, 'The error test failed')
            assert(false);
        end
    end
    
    % minimum and maximum indices
    try
        x(0) = 1;
        error('The error test failed')
    catch me
        if isequal(me.message, 'The error test failed')
            assert(false);
        end
    end
    try
        x(1,0) = 1;
        error('The error test failed')
    catch me
        if isequal(me.message, 'The error test failed')
            assert(false);
        end
    end
    try
        x(20) = 1;
        error('The error test failed')
    catch me
        if isequal(me.message, 'The error test failed')
            assert(false);
        end
    end
    
    % index is numeric
    try
        x('1') = 2;
        error('The error test failed')
    catch me
        if isequal(me.message, 'The error test failed')
            assert(false);
        end
    end
    
    % cannot assign vector to nothing
    try
        x([]) = [1 2];
        error('The error test failed')
    catch me
        if isequal(me.message, 'The error test failed')
            assert(false);
        end
    end
    
    % cannot change number of elements
    try
        x(1:2) = [1 2 3];
        error('The error test failed')
    catch me
        if isequal(me.message, 'The error test failed')
            assert(false);
        end
    end
    
    % we cannot create an object of more than 2 dimensions
    try
        x(1:2,1:2) = [1 2 3; 1 2 3];
        error('The error test failed')
    catch me
        if isequal(me.message, 'The error test failed')
            assert(false);
        end
    end
    
    % we don't accept assignment if a transposition is needed first
    try
        x(1:2,1:3) = [1 2 3; 4 5 6]';
        error('The error test failed')
    catch me
        if isequal(me.message, 'The error test failed')
            assert(false);
        end
    end
end
