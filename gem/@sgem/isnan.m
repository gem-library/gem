% isnan - True for NaN elements
function result = isnan(this)

objId = this.objectIdentifier;
result = logical(sgem_mex('isnan', objId));

end
