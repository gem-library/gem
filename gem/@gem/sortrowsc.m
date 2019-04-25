% sortrowsc - c implementation of sortrow algorithm, called by sortrow.m
%
% supported formats :
%   I = sortrow(a) : sorts out the rows of a
%   I = sortrow(a, signs) : sorts out the rows of a with respect to the
%       signs provided (>0 ascending, <=0 descending; the values are ignored)
function I = sortrowsc(this, signs)
    % Input management
    if nargin < 2
        error('Not enough arguments');
    end

    if ~isequal(round(signs), signs)
        error('Not the right number of signs');
    end

    if ~isreal(this)
        error('The input must be real');
    end

    % Now we call the appropriate sorting method
    objId = this.objectIdentifier;
    I = gem_mex('sortrowsc', objId, double(signs > 0));

    % Indices in matlab start from 1
    I = I+1;

end
