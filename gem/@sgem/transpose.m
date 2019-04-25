% transpose - computes the hermitian conjugate
function result = transpose(this)
    % We call the transpose procedure. Since the function creates a
    % new object with the result, we keep the corresponding handle...
    objId = this.objectIdentifier;
    newObjectIdentifier = sgem_mex('transpose', objId);

    % ...  and create a new matlab object to keep this handle
    result = sgem('encapsulate', newObjectIdentifier);
end
