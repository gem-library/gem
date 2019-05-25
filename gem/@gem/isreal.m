% isreal - tells whether the matrix is real
function result = isreal(this)
    % We call the isreal procedure
    objId = this.objectIdentifier;
    result = gem_mex('isreal', objId);
end
