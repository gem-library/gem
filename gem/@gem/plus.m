% plus - adds two matrices
function result = plus(this, varargin)
    % This is a function which involves a second instance of a similar object,
    % so we check if this second instance was also provided
    if length(varargin) ~= 1
        error('Wrong number of arguments in gem::plus');
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

    % Now we also check whether both objects are of type gem,
    % otherwise we convert them
    if ~isequal(class(this), 'gem')
        this = gem(this);
    elseif ~isequal(class(varargin{1}), 'gem')
        varargin{1} = gem(varargin{1});
    end

    % Now we call the addition procedure. Since the function creates a
    % new object with the result, we keep the corresponding handle...
    objId1 = this.objectIdentifier;
    objId2 = varargin{1}.objectIdentifier;
    newObjectIdentifier = gem_mex('plus', objId1, objId2);

    % ...  and create a new matlab object to keep this handle
    result = gem('encapsulate', newObjectIdentifier);
end
