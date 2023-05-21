% gammaln - logarithm of the gamma function
function result = gammaln(this)
    % We call the gammaln procedure. Since the function creates a
    % new object with the result, we keep the corresponding handle...
    objId = this.objectIdentifier;
    newObjectIdentifier = gem_mex('gammaln', objId);

    % ...  and create a new matlab object to keep this handle
    result = gem('encapsulate', newObjectIdentifier);
end
