% cot - cotangent function
function result = cot(this)
    % We call the cot procedure. Since the function creates a
    % new object with the result, we keep the corresponding handle...
    objId = this.objectIdentifier;
    newObjectIdentifier = gem_mex('cot', objId);

    % ...  and create a new matlab object to keep this handle
    result = gem('encapsulate', newObjectIdentifier);
end
