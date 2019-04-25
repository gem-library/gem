% tan - tangent function
function result = tan(this)
    % We call the tan procedure. Since the function creates a
    % new object with the result, we keep the corresponding handle...
    objId = this.objectIdentifier;
    newObjectIdentifier = sgem_mex('tan', objId);

    % ...  and create a new matlab object to keep this handle
    result = sgem('encapsulate', newObjectIdentifier);
end
