% find - Find indices of nonzero elements
%
% Supported formats:
%   I = find(x)            Returns the linear indices I for which x(I) ~= 0
%   I = find(x,k)          Returns the linear indices of at most k of the
%                          first non-zero elements in x
%   I = find(x,k,'first')  Same as above
%   I = find(x,k,'last')   Rather returns at most k of the last nonzero
%                          elements in x
%   I = find(x)            Returns the linear indices I for which x(I) ~= 0
%   [I, J] = find(x)       Returns the indices for which x(I(k),J(k)) ~= 0
%   [I, J, V] = find(x)    Also returns the nonzero values V
function [I, J, V] = find(this, k, mode)
    if (nargin >= 2) && ((numel(k) ~= 1) || (~isnumeric(k)))
        error('Unknown parameter in sgem::find');
    end
    if (nargin >= 3) && (~isequal(lower(mode), 'first')) && (~isequal(lower(mode), 'last'))
        error('Unknown parameter in sgem::find');
    end

    % k should be a double
    if (nargin >= 2) && ~isequal(class(k), 'double')
        k = double(k);
    end
    
    % If there is nothing to find
    if isempty(this)
        I = [];
        J = [];
        V = gem([]);
        return;
    end
    
    % we check the type of this and call another procedure if appropriate
    if isa(this, 'double')
        [I, J, V] = find(this, k, mode);
        if size(this,1) == 1
            I = I.';
            J = J.';
            V = V.';
        end
    else
        objId = this.objectIdentifier;
        [I, J, V] = sgem_mex('find', objId);
        % Indices in matlab start from 1
        I = I+1;
        J = J+1;
        % The third result is a gem object
        V = gem('encapsulate',V);
    end

    if (nargin >= 2)
        k = min(k, length(I));
        if (nargin < 3) || (isequal(lower(mode), 'first'))
            I = I(1:k);
            J = J(1:k);
            sub.type='()';
            sub.subs={[1:k]};
            V = subsref(V, sub);
        else
            I = I(end-k+1:end);
            J = J(end-k+1:end);
            sub.type='()';
            sub.subs={[length(V)-k+1:length(V)]};
            V = subsref(V, sub);
        end
    end

    % For row vectors, the outputs are row vectors
    if size(this,1) == 1
        I = I.';
        J = J.';
        V = V.';
    end
    if nargout <= 1
        % We translate the indices into linear indices
        I = size(this,1)*(J-1) + I;
    end
end
