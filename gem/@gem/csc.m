% csc - cosecant function
function result = csc(this)
    % We call the csc procedure. Since the function creates a
    % new object with the result, we keep the corresponding handle...
    objId = this.objectIdentifier;
    newObjectIdentifier = gem_mex('csc', objId);

    % ...  and create a new matlab object to keep this handle
    result = gem('encapsulate', newObjectIdentifier);
end
