% rank - number of linearly independent lines in the matrix
function result = rank(this)
    % We call the rank procedure.
    objId = this.objectIdentifier;
    result = gem_mex('rank', objId);
end
