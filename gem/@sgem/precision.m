% precision of each real matrix element
function result = precision(this)
    objId = this.objectIdentifier;
    result = sgem_mex('precision', objId);
end
