% checkIdentifierValidity - checks whether the c++ pointer class to the
% underlying c++ object that this class instance refers to exists in memory
function result = checkIdentifierValidity(this)
    objId = this.objectIdentifier;
    result = sgem_mex('isValid', objId);
end
