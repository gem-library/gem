% mldivide
%
% Only simplest cases are supported at the moment
function result = mldivide(this, varargin)
    % This is a function which involves a second instance of a similar object,
    % so we check if this second instance was also provided
    if length(varargin) ~= 1
        error('Wrong number of arguments in gem::mldivide');
    end

    % If the second type is more elaborated than just a number, we let the
    % corresponding class take care of performing the operation
    if ~isnumeric(varargin{1})
        result = mrdivide(varargin{1}', this')';
        return;
    end

    % We check that the denominator is a scalar
    if numel(this) == 1
        result = varargin{1}./this;
        return;
    end
    
    % We check whether the dimensions match
    if size(this,1) ~= size(varargin{1},1)
        error('Size mismatch in gem::mldivide');
    end

    % empty case
    if isempty(this) || isempty(varargin{1})
        result = gem([]);
        return;
    end
    
    % We check the conditioning number of the matrix
    rcond = 1/cond(gemify(this));
    if rcond < 10^(3-gem.workingPrecision)
        warning(['Matrix is close to singular. Result may be inaccurate. RCOND = ', toStrings(rcond,5)]);
    end

    % Now we also check the type of both objects
    % First we make sure that both object are either full of sparse gems
    if ~isequal(class(this), 'gem') && ~isequal(class(this), 'sgem')
        this = gemify(this);
    end
    if ~isequal(class(varargin{1}), 'gem') && ~isequal(class(varargin{1}), 'sgem')
        varargin{1} = gemify(varargin{1});
    end
    % We only support solving a dense system with a dense solution
    if isequal(class(this), 'gem') && isequal(class(varargin{1}), 'sgem')
        varargin{1} = full(varargin{1});
    end

    % Now we call the appropriate division procedure, and store the
    % result in the adequate object.
    if isequal(class(this), 'gem')
        objId1 = this.objectIdentifier;
        objId2 = varargin{1}.objectIdentifier;
        newObjectIdentifier = gem_mex('mldivide', objId1, objId2);
        result = gem('encapsulate', newObjectIdentifier);
    else
        if isequal(class(varargin{1}), 'gem')
            objId1 = this.objectIdentifier;
            objId2 = varargin{1}.objectIdentifier;
            newObjectIdentifier = sgem_mex('mldivide_sf', objId1, objId2);
            result = gem('encapsulate', newObjectIdentifier);
        else
            % A priori we should not arrive here...
            objId1 = this.objectIdentifier;
            objId2 = varargin{1}.objectIdentifier;
            newObjectIdentifier = sgem_mex('mldivide', objId1, objId2);
            result = sgem('encapsulate', newObjectIdentifier);
        end
    end

end
