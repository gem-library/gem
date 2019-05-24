function test_suite = gem_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    % various constructors
    assert(isempty(gem))
    
    x = gem(1);
    y = sgem(1);
    assert(isequal(x, gem(x)));
    assert(isequal(x, gem(y)));

    z = uint32(4);
    assert(uint32(double(gem(z))) == z);
    
    z = single(4.1);
    assert(single(double(gem(z))) == z);
    
    assert(abs(gem('log2') - 0.6931471805599453094) < 1e-5);
    assert(abs(gem('pi') - 3.1415926535897932385) < 1e-5);
    assert(abs(gem('e') - 2.7182818284590452354) < 1e-5);
    assert(abs(gem('euler') - 0.5772156649015328606) < 1e-5);
    assert(abs(gem('catalan') - 0.9159655941772190151) < 1e-5);

    assert(abs(gem('123.4+5.6i') - (123.4+5.6i)) < 1e-5);
    assert(abs(gem('123.4+5.6i', 2) - (123.4+5.6i)) > 1e-5);
    
    assert(abs(gem('123e-2') - (1.23)) < 1e-5);

    assert(precision(gem('24187658761246014609186358071360487246327480125801759037587107624610460237462469234081248023123414872424618608123480214237491724')) == 128)

    assert(sum(abs(gem({2, 4i, '234', '2 + 0.5i'}) - [2, 4i, 234, 2+0.5i])) < 1e-5);
    
    assert(precision(gem(765.3, 132)) == 132)
    assert(precision(gem('765.3', 132)) == 132)
    assert(precision(gem('24187658761246014609186358071360487246327480125801759037587107624610460237462469234081248023123414872424618608123480214237491724',12)) == 12)

    
    %% Sub-functions
    tmp = gem(1);
    delete(tmp);
    clear tmp;
    
    gem.workingPrecision(gem(gem.workingPrecision));
    gem.displayPrecision(gem(gem.displayPrecision));
end

function test_inputs
    shouldProduceAnError(@() gem('123.2.4 + 2i'));
    
    shouldProduceAnError(@() gem('-1e5+2'));

    shouldProduceAnError(@() gem('-1e5+2', [1 2]));

    shouldProduceAnError(@() gem('F'));
    
    shouldProduceAnError(@() gem('1+3it',2));

    shouldProduceAnError(@() gem({1, {}}));
    
    shouldProduceAnError(@() gem({1, 'F'}));
    
    shouldProduceAnError(@() gem({1, [2;3]}));
    
    shouldProduceAnError(@() gem(@(x) x));
    
    shouldProduceAnError(@() gem('encapsulate', uint64(2)));
    
    shouldProduceAnError(@() gem(12.3, 0));
    
    shouldProduceAnError(@() gem(1, 2, 3));    

    % Sub-functions
    shouldProduceAnError(@() gem.workingPrecision(-1));
end
