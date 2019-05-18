% svd - Singular value decomposition
%
% supported formats :
%   s = svd(a)              : singular values of a
%   s = svd(a,'econ')       : singular values of a
%   [u s v] = svd(a,'econ') : singular values of a with left and right
%                             economic singular vectors u and v (a = u*s*v')
%
% Option 'econ' can be replaced by 0 as well.
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
    
    % We check if the arguments are fine
    if ((nargout > 1) || (nargin >= 2)) && ((length(varargin) < 1) || (~isequal(varargin{1},'econ') && ((numel(varargin{1}) ~= 1) || (varargin{1} ~= 0))))
        error('Only the economic decomposition is available in gem::svd');
    end

    % We perform the computation
    if nargout <= 3
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

    else
        error('Unsupported call to gem::svd')
    end

end
