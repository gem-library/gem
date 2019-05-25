% Save the c++ object with matlab
%
% Note : This saves only the significant digits. Therefore, calling loadobj
% with the structure created by this function may produce a result which
% varies from the saved object by an amount of the order of
% gem.workingPrecision. Unless manually changed, this produces an error of
% the order 1e-50.
function structure = saveobj(this)
    % This function should return a matlab structure that fully characterizes the current object
    objId = this.objectIdentifier;
    structure = sgem_mex('saveobj', objId);
    % We add the format version
    structure.dataVersion = 1.0;
end
