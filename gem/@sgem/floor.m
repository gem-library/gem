% floor - rounds towards minus infinity
function result = floor(this)
    % We call the floor procedure. Since the function creates a
    % new object with the result, we keep the corresponding handle...
    objId = this.objectIdentifier;
    newObjectIdentifier = sgem_mex('floor', objId);

    % ...  and create a new matlab object to keep this handle
    result = sgem('encapsulate', newObjectIdentifier);
end
