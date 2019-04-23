% imag - extracts the imaginary part of a complex number
function result = imag(this)
    % We call the imag procedure. Since the function creates a
    % new object with the result, we keep the corresponding handle...
    objId = this.objectIdentifier;
    newObjectIdentifier = gem_mex('imag', objId);

    % ...  and create a new matlab object to keep this handle
    result = gem('encapsulate', newObjectIdentifier);
end
