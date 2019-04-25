% Convert the data to a matlab strings (or a cell thereof)
function result = toStrings(this, precision)

    if nargin < 2
        precision = -1;
    else
        precision = double(precision);
    end

    objId = this.objectIdentifier;
    result = gem_mex('toStrings', objId, precision);

    if numel(result) == 1
        result = result{1};
    end
end
