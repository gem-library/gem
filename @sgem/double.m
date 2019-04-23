% Convert the data to a sparse table of matlab double
function result = double(this)
    objId = this.objectIdentifier;
    result = sgem_mex('double', objId);
end
