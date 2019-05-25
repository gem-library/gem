% rdivide - element-wise right division A./B
function result = rdivide(this, varargin)
    % This is a function which involves a second instance of a similar object,
    % so we check if this second instance was also provided
    if length(varargin) ~= 1
        error('Wrong number of arguments in sgem::rdivide');
    end

    % If the second type is more elaborated than just a number, we let the
    % corresponding class take care of performing the operation
    if ~isnumeric(varargin{1})
        result = ldivide(varargin{1}, this);
        return;
    end

    % We need to check that the operation is possible (the c++
    % library might give bad errors otherwise). So we request the
    % dimensions of each matrix
    size1 = size(this);
    size2 = size(varargin{1});

    if (~isequal(size1, size2)) && (prod(size1) ~= 1) && (prod(size2) ~= 1) && (prod(size1)+prod(size2) > 0)
        error('Incompatible size for element-wise division');
    end
    
    % This function preserves the sparsity only if A is sparse and B is a scalar.
    if issparse(this) && (numel(varargin{1}) == 1)
        % We check that both objects are of type sgem,
        % otherwise we convert them
        if ~isequal(class(this), 'sgem')
            this = sgem(this);
        elseif ~isequal(class(varargin{1}), 'sgem')
            varargin{1} = sgem(varargin{1});
        end

        % We call the rdivide procedure. Since the function creates a
        % new object with the result, we keep the corresponding handle...
        objId1 = this.objectIdentifier;
        objId2 = varargin{1}.objectIdentifier;
        newObjectIdentifier = sgem_mex('rdivide', objId1, objId2);

        % ...  and create a new matlab object to keep this handle
        result = sgem('encapsulate', newObjectIdentifier);
    else
        % If the result is not sparse, we compute this function on the full variables
        result = rdivide(full(this), full(varargin{1}));

        % For matlab, division of a sparse matrix is always a sparse matrix
        if sgem.sparseLikeMatlab == 1
            result = sparse(result);
        end
    end
end
