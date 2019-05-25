function test_suite = reshape_test()
    try
        test_functions = localfunctions();
    catch
    end
    initTestSuite;
end

function test_consistency
    x = {sparse(gemRand(1,12)-1/2), sparse((gemRand(1,12)-1/2)*1i), sparse(gemRand(1,12)-1/2 + (gemRand(1,12)-1/2)*1i)};
    validateDoubleConsistency(@(x) reshape(x, 2, 6), x);
    validateDoubleConsistency(@(x) reshape(x, [4 3]), x);
    validateDoubleConsistency(@(x) reshape(x, 1, 12), x);
    validateDoubleConsistency(@(x) reshape(x, 12, 1), x);
    
    validateDoubleConsistency(@(x) reshape(x, [], 3), x);
    validateDoubleConsistency(@(x) reshape(x, 3, []), x);
end

function test_empty
    assert(isempty(reshape(sgem([]),0,0)));
end

function test_inputs
    % at most three arguments
    shouldProduceAnError(@() reshape(sgem([1 2 3]), 1, 2, 3));
    
    % with two arguments, second one must have 2 elements
    shouldProduceAnError(@() reshape(sgem([1 2 3]), [1 2 3]));
    
    % with three arguments, at least one dimension must be specified
    shouldProduceAnError(@() reshape(sgem([1 2 3]), [], []));

    % dimension must be a divisor of number of elements
    shouldProduceAnError(@() reshape(sgem([1 2 3]), 2, []));
    shouldProduceAnError(@() reshape(sgem([1 2 3]), [], 2));

    % number of elements must be invariant
    shouldProduceAnError(@() reshape(sgem([1 2 3]), 2, 2));
end
