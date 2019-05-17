% checkIdentifierValidity - checks whether the c++ pointer class to the
% underlying c++ object that this class instance refers to is of the
% correct type. Returns 1 if it is the case, 0 if the pointed object is of
% a different type (e.g. is the pointer to a sgem object). Since a
% segmentation fault is created if the pointer is invalid, the
% objectIdentifier property should not be modifiable by the user.
function result = checkIdentifierValidity(this)
    objId = this.objectIdentifier;
    result = gem_mex('isValid', objId);
end
