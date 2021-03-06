% cbrt - element-wise cubic root
function result = cbrt(this)
    % First we check that the matrix only contains positive real numbers
    if (~isreal(this)) || (min(min(this)) < 0)
        % Then we cannot use the quick computation. We use a generic one instead
        result = this.^(1/gem(3));
        return;
    end

    % We call the cbrt procedure. Since the function creates a
    % new object with the result, we keep the corresponding handle...
    objId = this.objectIdentifier;
    newObjectIdentifier = sgem_mex('cbrt', objId);

    % ...  and create a new matlab object to keep this handle
    result = sgem('encapsulate', newObjectIdentifier);
end
