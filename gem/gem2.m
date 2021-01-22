% gem2 - performs a binary conversion from double to gem
%
% This conversion is performed by adding zeros in the binary expansion 
% of the number. This allows to keep the maximum amount of information 
% from the provided number (double has a binary encoding). However, this
% can lead to surprising results, such as 
%   >> gem2(1/3)
%     0.3333333333333333148
%   >> gem2(1/3) - 1/3
%     1e-16 *
%      3.1482961625624739099
%   >> gem2(1/3) - 1/gem(3)
%     1e-17 *
%     -1.8503717077085942340
%
% In contrast:
%   >> gem(1/3)
%     0.3333333333333330000
%   >> gem(1/3) - 1/3
%      0
%   >> gem(1/3) - 1/gem(3)
%     1e-16 *
%     -3.3333333333333333333
function result = gem2(x)
    % gem/sgem objects are already in high precision, we keep them
    if isa(x, 'gem')
        result = x;
        return;
    elseif isa(x, 'sgem')
        result = full(x);
        return;
    end
    
    assert(isa(x, 'double'), 'Argument is not a double');

    objectIdentifier = gem_mex('newFromMatlabBinary', full(x), gem.workingPrecision);

    result = gem('encapsulate', objectIdentifier);
end
