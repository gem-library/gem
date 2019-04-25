% nnz - number of non-zero elements in the matrix
function result = nnz(this)
    % We call the nnz procedure.
    objId = this.objectIdentifier;
    result = sgem_mex('nnz', objId);
end
