% kron - kronecker tensor product of two or more matrices
function result = kron(this, varargin)
    % This is a function which involves at least a second instance of a similar object,
    % so we check if this second instance was also provided
    if length(varargin) < 1
        error('Wrong number of arguments in sgem::kron');
    end

    % If there are more than two arguments, we compute each kronecker
    % product iteratively
    if length(varargin) >= 2
        result = this;
        for i = 1:length(varargin)
            result = kron(result, varargin{i});
        end
        return;
    end

    % Now we also check the type of both objects
    % First we make sure that both object are either full of sparse gems
    if ~isequal(class(this), 'gem') && ~isequal(class(this), 'sgem')
        this = gemify(this);
    end
    if ~isequal(class(varargin{1}), 'gem') && ~isequal(class(varargin{1}), 'sgem')
        varargin{1} = gemify(varargin{1});
    end


    % Now we call the appropriate kron procedure, and store the
    % result in the adequate object.
    if isequal(class(this), 'gem')
        if isequal(class(varargin{1}), 'gem')
            % A priori we should not arrive here...
            objId1 = this.objectIdentifier;
            objId2 = varargin{1}.objectIdentifier;
            newObjectIdentifier = gem_mex('kron', objId1, objId2);
            result = gem('encapsulate', newObjectIdentifier);
        else
            objId1 = this.objectIdentifier;
            objId2 = varargin{1}.objectIdentifier;
            newObjectIdentifier = gem_mex('kron_fs', objId1, objId2);
            result = sgem('encapsulate', newObjectIdentifier);
        end
    else
        if isequal(class(varargin{1}), 'gem')
            objId1 = this.objectIdentifier;
            objId2 = varargin{1}.objectIdentifier;
            newObjectIdentifier = sgem_mex('kron_sf', objId1, objId2);
            result = sgem('encapsulate', newObjectIdentifier);
        else
            objId1 = this.objectIdentifier;
            objId2 = varargin{1}.objectIdentifier;
            newObjectIdentifier = sgem_mex('kron', objId1, objId2);
            result = sgem('encapsulate', newObjectIdentifier);
        end
    end

end
