function test_suite = sgem_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    % various constructors
    assert(isempty(sgem))
    
    x = gem(1);
    y = sgem(1);
    assert(isequal(x, sgem(x)));
    assert(isequal(x, sgem(y)));

    z = uint32(4);
    assert(uint32(double(full(sgem(z)))) == z);
    
    z = single(4.1);
    assert(single(double(full(sgem(z)))) == z);
    
    assert(abs(sgem('log2') - 0.6931471805599453094) < 1e-5);
    assert(abs(sgem('pi') - 3.1415926535897932385) < 1e-5);
    assert(abs(sgem('e') - 2.7182818284590452354) < 1e-5);
    assert(abs(sgem('euler') - 0.5772156649015328606) < 1e-5);
    assert(abs(sgem('catalan') - 0.9159655941772190151) < 1e-5);

    assert(abs(sgem('123.4+5.6i') - (123.4+5.6i)) < 1e-5);
    %assert(abs(sgem('123.4+5.6i', 2) - (123.4+5.6i)) > 1e-5);
    
    assert(abs(sgem('123e-2') - (1.23)) < 1e-5);

    assert(precision(sgem('24187658761246014609186358071360487246327480125801759037587107624610460237462469234081248023123414872424618608123480214237491724')) == 128)

    assert(sum(abs(sgem({2, 4i, '234', '2 + 0.5i'}) - [2, 4i, 234, 2+0.5i])) < 1e-5);
    
    assert(precision(sgem(765.3, 132)) == 132)
    %assert(precision(sgem('765.3', 132)) == 132)
    %assert(precision(sgem('24187658761246014609186358071360487246327480125801759037587107624610460237462469234081248023123414872424618608123480214237491724',12)) == 12)

    assert(nnz(sgem(gem([1 2 3 4 5]), 2.5)) == 3)
    
    [i j s] = find(rand(1,3));
    i = [i 2];
    j = [j 2];
    s = [s 0];
    assert(sum(sum(abs(sgem(i,j,s) - [s(1) s(2) s(3); 0 0 0]))) < 1e-9);
    assert(sum(sum(abs(sgem(i,j,s(1)) - [s(1) s(1) s(1); 0 s(1) 0]))) < 1e-9);
    s = 0*s;
    assert(nnz(sgem(i,j,s)) == 0);
    assert(isequal(size(sgem(i,j,s)), [2 3]));
    s = uint32([1 2 3 4]);
    assert(sum(sum(abs(sgem(i,j,s) - [1 2 3; 0 4 0]))) < 1e-9);
    s = single([1 2 3 4]);
    assert(sum(sum(abs(sgem(i,j,s) - [1 2 3; 0 4 0]))) < 1e-9);
    
    s = gem({'12.3', '1e-12', 432, 123152});
    assert(sum(sum(abs(sgem(i,j,s) - [12.3 1e-12 432; 0 123152 0]))) < 1e-9);

    s = [123 456 789 102];
    assert(sum(sum(abs(sgem(i,j,s,2) - [123 456 789; 0 102 0]))) > 1e-3);
end

function test_inputs
    shouldProduceAnError(@() sgem('123.2.4 + 2i'));
    
    shouldProduceAnError(@() sgem('-1e5+2'));

    shouldProduceAnError(@() sgem('F'));
    
    shouldProduceAnError(@() sgem({1, {}}));
    
    shouldProduceAnError(@() sgem({1, 'F'}));
    
    shouldProduceAnError(@() sgem({1, [2;3]}));
    
    shouldProduceAnError(@() sgem(@(x) x));
    shouldProduceAnError(@() sgem(@(x) x, 2));
    shouldProduceAnError(@() sgem(@(x) x, 2, 3));
    shouldProduceAnError(@() sgem(@(x) x, 2, 3, 4));
    shouldProduceAnError(@() sgem(@(x) x, 2, 3, 4, 5));
    shouldProduceAnError(@() sgem(@(x) x, 2, 3, 4, 5, 6));
    
    shouldProduceAnError(@() sgem('encapsulate', uint64(2)));
    
    shouldProduceAnError(@() sgem(12.3, 0));
    
    shouldProduceAnError(@() sgem(1, 2, 3, [1 2]));
    shouldProduceAnError(@() sgem(1, 2, 3, 4, 5, 6, 7));
end