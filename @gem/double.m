% Convert the data to a table of matlab double
function result = double(this)
    objId = this.objectIdentifier;
    result = gem_mex('double', objId);
end
