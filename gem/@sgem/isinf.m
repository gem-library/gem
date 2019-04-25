% isinf - True for +Inf and -Inf elements
function result = isinf(this)

objId = this.objectIdentifier;
result = logical(sgem_mex('isinf', objId));

end
