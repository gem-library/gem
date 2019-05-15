% issymmetric - tells whether the matrix is symmetric, i.e. x == x.'
function result = issymmetric(this)
    % We call the issymmetric procedure
    objId = this.objectIdentifier;
    result = logical(gem_mex('issymmetric', objId));
end
