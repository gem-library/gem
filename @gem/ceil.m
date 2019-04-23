% ceil - rounds towards plus infinity
function result = ceil(this)
    % We call the ceiling procedure. Since the function creates a
    % new object with the result, we keep the corresponding handle...
    objId = this.objectIdentifier;
    newObjectIdentifier = gem_mex('ceil', objId);

    % ...  and create a new matlab object to keep this handle
    result = gem('encapsulate', newObjectIdentifier);
end
