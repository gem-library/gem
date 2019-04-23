% precision of each real matrix element
function result = precision(this)
    objId = this.objectIdentifier;
    result = gem_mex('precision', objId);
end
