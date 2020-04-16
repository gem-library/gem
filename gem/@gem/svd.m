% svd - Singular value decomposition
%
% supported formats :
%   s = svd(a)              : singular values of a
%   [u s v] = svd(a)        : singular values of a with singular vectors
%   [u s v] = svd(a,0)      : semi-economic decompositions
%   [u s v] = svd(a,'econ') : economic decompositions
function [U S V] = svd(this, varargin)
    % This function can involve at most one argument
    if length(varargin) > 1
        error('Wrong number of arguments in gem::svd');
    end

    if isempty(this)
        U = gem([]);
        S = gem([]);
        V = gem([]);
        return;
    end
    
    [m, n] = size(this);
    economical = (m == n) || (nargout <= 1);
    
    if (nargin >= 2)
        % Check the option
        if ~isequal(varargin{1}, 0) && ~isequal(varargin{1}, 'econ')
            error('unknown option for gem::svd');
        end

        if (nargout >= 2)
            economical = ~(isequal(varargin{1}, 0) && (m < n));
        end
    end
    
    if nargout > 3
        error('Unsupported call to gem::svd')
    end
    
    
    % We perform the computation
    if ~economical
        % We temporarily increase the size of the matrix
        objId = this.objectIdentifier;
        gem_mex('resize', objId, max(m, n), max(m, n));
    end

    objId = this.objectIdentifier;
    [newObjectIdentifierU newObjectIdentifierS newObjectIdentifierV] = gem_mex('svd', objId);

    % ...  and create a new matlab object to keep this handle
    U = gem('encapsulate', newObjectIdentifierU);
    S = gem('encapsulate', newObjectIdentifierS);
    V = gem('encapsulate', newObjectIdentifierV);

    % We normalize the singular vectors
    U = U*diag(1./sqrt(diag(U'*U)));
    V = V*diag(1./sqrt(diag(V'*V)));

    % To check whether the eigendecomposition is correct:
    % U*D-(this)*V
%         precision = double(abs(norm(mtimes(U,D) - mtimes(this,V),1)));
%         disp(['Singular value decomposition precision: ', num2str(precision)]);
%         if (precision > 1e-30)
%             disp('WARNING : big eigendecomposition error!!!');
%         end

    if nargout <= 1
        U = diag(S);
    end
    
    % If we extended the matrix, we restore it
    if ~economical
        % We restore the matrix size
        objId = this.objectIdentifier;
        gem_mex('resize', objId, m, n);
        
        % We remove the elements that were not requested
        if nargout >= 2
            if m < n
                U = subsref(U, struct('type', '()', 'subs', {{1:m, 1:m}}));
                S = subsref(S, struct('type', '()', 'subs', {{1:m, ':'}}));
            elseif m > n
                S = subsref(S, struct('type', '()', 'subs', {{':', 1:n}}));
                V = subsref(V, struct('type', '()', 'subs', {{1:n, 1:n}}));
            end
        end
    end

end
