% plus - adds two matrices
function result = plus(this, varargin)
    % This is a function which involves a second instance of a similar object,
    % so we check if this second instance was also provided
    if length(varargin) ~= 1
        error('Wrong number of arguments in sgem::plus');
    end

    % If the second type is more elaborated than just a number, we let the
    % corresponding class take care of performing the operation
    if ~isnumeric(varargin{1})
        result = plus(varargin{1}, this);
        return;
    end

    % We need to check that the operation is possible (the c++
    % library might give bad errors otherwise). So we request the
    % dimensions of each matrix
    size1 = size(this);
    size2 = size(varargin{1});

    if (~isequal(size1, size2)) && (prod(size1) ~= 1) && (prod(size2) ~= 1) && (prod(size1)+prod(size2) > 0)
        error('Incompatible size for matrix addition');
    end

    % Now we also check the type of both objects
    % First we make sure that both object are either full of sparse gems
    if ~isequal(class(this), 'gem') && ~isequal(class(this), 'sgem')
        this = gemify(this);
    end
    if ~isequal(class(varargin{1}), 'gem') && ~isequal(class(varargin{1}), 'sgem')
        varargin{1} = gemify(varargin{1});
    end

    % Now we call the appropriate procedure, and store the
    % result in the adequate object.
    if isequal(class(this), 'sgem') && isequal(class(varargin{1}), 'sgem') && isequal(size1, size2)
        objId1 = this.objectIdentifier;
        objId2 = varargin{1}.objectIdentifier;
        newObjectIdentifier = sgem_mex('plus', objId1, objId2);
        result = sgem('encapsulate', newObjectIdentifier);
    else
        result = full(this)+full(varargin{1});
    end

    % For matlab, addition between two sparse matrices is always sparse (even when adding a matrix with a scalar)
    if (sgem.sparseLikeMatlab == 1) && (issparse(this)) && (issparse(varargin{1})) && (~issparse(result))
        result = sparse(result);
    end
end
