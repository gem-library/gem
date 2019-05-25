% sort - sorts components
%
% supported formats :
%   sort(a) : sorts out elements of a along the first dimension in
%     ascending order
%   sort(a, dim) : sorts out elements of a along the first dimension dim
%   sort(a, mode) : mode is either 'ascend' or 'descend'
%   sort(a, dim, mode) : specifies both the dimension and the mode
%   [b I] = sort(a) : returns the indices I such that b = a(I)
function [result I] = sort(this, dim, mode)
    % Input management
    if nargin < 3
        mode = 'ascend';
    end

    if (nargin < 2) || ischar(dim)
        if (nargin >=2) && ischar(dim)
            mode = dim;
        end
        if size(this,1) ~= 1
            dim = 1;
        else
            dim = 2;
        end
    elseif ~isequal(class(dim), 'double')
        dim = double(dim);
    end

    if ~isequal(mode, 'ascend') && ~isequal(mode, 'descend')
        error('Sorting direction must be either ''ascend'' of ''descend''');
    end

    if (numel(dim) ~= 1) || (dim < 1) || (round(dim) ~= dim)
        error('Dim must be a positive integer');
    end

    % If there is nothing to sort
    if isempty(this) || (dim >= 3)
        result = this;
        if nargout > 1
            I = ones(size(this));
        end
        return;
    end

    % we check the type of this and call another procedure if appropriate
    if isa(this, 'double')
        [result I] = sort(this, double(dim), mode);
        return;
    end
    
    % Now we call the appropriate sorting method
    objId = this.objectIdentifier;
    [newObjectIdentifier I] = gem_mex('sort', objId, dim-1, double(isequal(mode, 'descend')));

    % Indices in matlab start from 1
    I = I+1;

    % ...  and create a new matlab object to keep this handle
    result = gem('encapsulate', newObjectIdentifier);
end
