% isnan - True for NaN elements
function result = isnan(this)

objId = this.objectIdentifier;
result = logical(gem_mex('isnan', objId));

end
