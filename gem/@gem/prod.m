% prod - Product of elements
%
% supported formats :
%   prod(a) : column-wise product
%   prod(a, dim) : product along the dimension dim
%   prod(a, 'all') : product of all elements
function result = prod(this, dim)
    if nargin < 2
        if size(this,1) ~= 1
            dim = 1;
        else
            dim = 2;
        end
    end

    % Now we call the element-wise minimum procedure. Since the function creates a
    % new object with the result, we keep the corresponding handle...
    switch dim
        case 'all'
            objId = this.objectIdentifier;
            newObjectIdentifier = gem_mex('prod', objId);
        case 1
            objId = this.objectIdentifier;
            newObjectIdentifier = gem_mex('colProd', objId);
        case 2
            objId = this.objectIdentifier;
            newObjectIdentifier = gem_mex('rowProd', objId);
        otherwise
            error('Unexpected argument in gem::prod');
    end

    % ...  and create a new matlab object to keep this handle
    result = gem('encapsulate', newObjectIdentifier);
end
