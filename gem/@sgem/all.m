% all - True if all elements are nonzero
%
% supported formats:
%   all(x)
%   all(x,dim)
%   all(x,'all')
function result = all(this, dim)
    if (nargin == 2)
        if isequal(dim, 'all')
            result = (sum(sum(this~=0)) == numel(this)); % octave doesn't support sum(x, 'all')
            return;
        elseif ~isnumeric(dim)
            error('Bad input in sgem::all');
        end
    elseif (nargin < 2) && (min(size(this)) > 1)
        % For matrices, we act by default on the columns
        dim = 1;
    elseif nargin < 2
        result = (sum(this~=0) == length(this));
        return;
    end

    % We look along a given dimension
    if numel(dim) ~= 1 || (round(dim) ~= dim) || (dim < 1)
        error('Dim must be a positive integer');
    end
    result = (sum(this~=0,dim) == size(this,dim));
end
