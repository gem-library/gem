% asin - arc sine function
function result = asin(this)
    % We call the asin procedure. Since the function creates a
    % new object with the result, we keep the corresponding handle...
    objId = this.objectIdentifier;
    newObjectIdentifier = sgem_mex('asin', objId);

    % ...  and create a new matlab object to keep this handle
    result = sgem('encapsulate', newObjectIdentifier);
end
