% sgem2 - performs a binary conversion from double to sgem
%
% This conversion is performed by adding zeros in the binary expansion 
% of the number. This allows to keep the maximum amount of information 
% from the provided number (double has a binary encoding). However, this
% can lead to surprising results, see gem2.m
function result = sgem2(x)
    % gem/sgem objects are already in high precision, we keep them
    if isa(x, 'gem')
        result = sparse(x);
        return;
    elseif isa(x, 'sgem')
        result = x;
        return;
    end
    
    assert(isa(x, 'double'), 'Argument is not a double');

    [m n] = size(x);
    [i j s] = find(x);

    objectIdentifier = sgem_mex('newFromMatlabBinary', i, j, s, m, n, sgem.workingPrecision);

    result = sgem('encapsulate', objectIdentifier);
end
