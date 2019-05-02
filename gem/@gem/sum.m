% sum - Sum of elements
%
% supported formats :
%   sum(a) : column-wise sum
%   sum(a, dim) : sum along the dimension dim
%   sum(a, dim, type) : sum along the dimension dim and type can be any of
%       the following:
%        - double : the output will be recast in double type
%        - native or default : the output is of gem type
%   sum(a, 'all') : sum all elements
%   sum(a, 'all', 'type') : sum all elements with type as above
function result = sum(this, dim, type)
    % This function can involve up to three arguments
    if (nargin < 3)
        type = 'native';
    else
        if ~isequal(type, 'double') && ~isequal(type, 'native') && ~isequal(type, 'default')
            error('Unsupported argument in gem::sum');
        end
    end

    if nargin < 2
        if size(this,1) ~= 1
            dim = 1;
        else
            dim = 2;
        end
    end

    % Now we call the relevant sum procedure. Since the function creates a
    % new object with the result, we keep the corresponding handle...
    switch dim
        case 'all'
            objId = this.objectIdentifier;
            newObjectIdentifier = gem_mex('sum', objId);
        case 1
            objId = this.objectIdentifier;
            newObjectIdentifier = gem_mex('colSum', objId);
        case 2
            objId = this.objectIdentifier;
            newObjectIdentifier = gem_mex('rowSum', objId);
        otherwise
            error('Unexpected argument in gem::sum');
    end

    % ...  and create a new matlab object to keep this handle
    result = gem('encapsulate', newObjectIdentifier);

    % If the user requested double output, we transform the output
    % accordingly
    if isequal(type, 'double')
        result = double(result);
    end
end
