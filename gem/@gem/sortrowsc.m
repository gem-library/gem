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

    % One sign per columns
    if ~isequal(size(signs), [1 size(this,2)]) && ~isequal(size(signs), [size(this,2) 1])
        error('Not the right number of signs');
    end
    
    if size(signs,1) > size(signs,2)
        signs = signs.';
    end

    % input must be real
    if ~isreal(this)
        error('The input must be real');
    end

    % We call the appropriate method
    if isa(this, 'double')
        % Octave doesn't support sortrowsc
        isOctave = exist('OCTAVE_VERSION', 'builtin') ~= 0;
        if isOctave
            this = gem(this);
        else
            I = sortrowsc(this, double(signs));
            return;
        end
    end
    
    % Now we call the appropriate sorting method
    objId = this.objectIdentifier;
    I = gem_mex('sortrowsc', objId, double(signs > 0));

    % Indices in matlab start from 1
    I = I+1;
end
