% eig - eigenvalues and eigenvectors
%
% supported formats :
%   e = eig(a)     : eigenvalues of a
%   [v d] = eig(a) : eigenvectors and eigenvalues of a (a*v = v*d)
function [V D] = eig(this, varargin)
    % This function can involve only one argument
    if length(varargin) >= 1
        error('Wrong number of arguments in gem::eig');
    end
    
    if isempty(this)
        V = gem([]);
        D = gem([]);
        return;
    end

    % The matrix must be square
    if size(this, 1) ~= size(this,2)
        error('Matrix must be square in gem::eig');
    end

    objId = this.objectIdentifier;
    [newObjectIdentifierV newObjectIdentifierD] = gem_mex('eig', objId);

    % ...  and create a new matlab object to keep this handle
    V = gem('encapsulate', newObjectIdentifierV);
    D = gem('encapsulate', newObjectIdentifierD);
    
    % In rare occations the decomposition might fail. It then returns empty
    % results. We check if this was the case.
    if isempty(V) || isempty(D)
        warning('The eigendecomposition failed (we are possibly in presence of a complex non-hermitian matrices with degenerate eigenvalues)');
    end
    
    % We normalize the eigenvectors (this should not be done if the
    % option 'nobalance' is passed (once this option is implemented).
    V = V*diag(1./sqrt(diag(V'*V)));

    if nargout <= 1
        V = diag(D);
    end

end
