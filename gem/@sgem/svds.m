% svds - Partial singular value decomposition
%
% supported formats :
%   s = svds(a, [k])            : k largest singular values of a
%   [u s v] = svds(a, [k])      : k largest singular values of a with left
%                                 and right economic singular vectors u and
%                                 v: s = u'*a*v. The columns of u and v are 
%                                 orthonormal, i.e. u'*u = id, v'*v = id.
%   [u s v] = svds(a, k, sigma) : sigma = 'largest', 'smallest' for the
%                                 largest or smallest singular values
%
% The default value of k is 6.
function [U S V] = svds(this, varargin)
    % This function can involve at most two parameters
    if length(varargin) > 2
        error('Wrong number of arguments in sgem::svds');
    end
    
    if (length(varargin) > 0) && (~isnumeric(varargin{1}) || (numel(varargin{1}) ~= 1))
        error('The second argument of sgem::svds must be a single number');
    elseif (length(varargin) > 0) && ~isequal(class(varargin{1}), 'double')
        % We make sure that the number of eigenvalues to be computed was
        % specified as a double
        varargin{1} = double(varargin{1});
    end
    
    % Extract the requested number of singular values
    if length(varargin) > 0
        nbSingularvalues = varargin{1};
    else
        nbSingularvalues = min(size(this,1), 6);
    end
    
    % The number of singular values computed must be larger than zero
    if (nbSingularvalues == 0) || isempty(this)
        U = gem([]);
        S = gem([]);
        V = gem([]);
        return;
    elseif nbSingularvalues < 0
        error('sgem::svds cannot compute a negative number of eigenvalues');
    end
    
    % We check if there is a second parameter
    if (length(varargin) > 1) && (~ischar(varargin{2}))
        error('The third argument of sgem::svds must be a text');
    end

    % We extract the requested type of singular values
    type = 'lm';
    if length(varargin) > 1
        switch lower(varargin{2})
            case 'largest'
                % Largest singular values
                type = 'lm';
            case 'smallest'
                % Smallest singular values
                type = 'sm';
            otherwise
                error('Third argument of sgem::svds not recognized');
        end
    end
    
    if nbSingularvalues > size(this,1) - 2 + ishermitian(this)
        % We cannot extract more than this number of singular values
        if nbSingularvalues > size(this,1)
            error('Too many singular values asked for in sgem::svds');
        end
        
        % We use svd on full matrices to compute all singular values if the
        % size is small
        if size(this,1) <= 20
            this = full(this);
            if nargout >= 2
                [U S V] = svd(this,'econ');
                if isequal(type, 'sm')
                    subU.type='()';
                    subU.subs={[1:size(U,1)] [size(U,2)-nbSingularvalues+1:size(U,2)]};
                    U = subsref(U, subU);
                    subS.type='()';
                    subS.subs={[size(S,1)-nbSingularvalues+1:size(S,1)] [size(S,2)-nbSingularvalues+1:size(S,2)]};
                    S = subsref(S, subS);
                    subV.type='()';
                    subV.subs={[1:size(V,1)] [size(V,2)-nbSingularvalues+1:size(V,2)]};
                    V = subsref(V, subV);
                elseif nbSingularvalues < size(S,1)
                    subU.type='()';
                    subU.subs={[1:size(U,1)] [1:nbSingularvalues]};
                    U = subsref(U, subU);
                    subS.type='()';
                    subS.subs={[1:nbSingularvalues] [1:nbSingularvalues]};
                    S = subsref(S, subS);
                    subV.type='()';
                    subV.subs={[1:size(V,1)] [1:nbSingularvalues]};
                    V = subsref(V, subV);
                end
            else
                U = svd(this);
                if isequal(type, 'sm')
                    subU.type='()';
                    subU.subs={[size(U,1)-nbSingularvalues+1:size(U,1)] [1]};
                    U = subsref(U, subU);
                elseif nbSingularvalues < size(U,1)
                    subU.type='()';
                    subU.subs={[1:nbSingularvalues] [1]};
                    U = subsref(U, subU);
                end
            end
            return;
        else
            error('Too many singular values for sgem::svds.');
        end
    end
    
    % Should we invert the dimensions?
    invertMode = 0;
    if size(this,1) > size(this,2)
        invertMode = 1;
        this = this';
    end
    
    if isequal(type, 'sm')
        % If we reach here, we're going to look for the smallest eigenvalue
        % of a positive semi-definite matrix. To avoid trouble with zero
        % eigenvalues, we look for the eigenvalues closest to -1.
        type = -1;
    end
    
    % We perform the computation
    if nargout <= 1
        % We only compute the eigenvalues of a*a'
        vals = eigs(this*this', [], nbSingularvalues, type);
        vals = max(vals,0); % We round up eventual slightly negative values
        U = sqrt(vals);
        
        % We make sure the order of the singular values is decreasing
        if isequal(type,-1)
            subU.type='()';
            subU.subs={[size(U,1):-1:1]};
            U = subsref(U, subU);
        end
    elseif nargout <= 2
        % We compute the eigenvalues and eigenvectors of a*a'
        [U valsU] = eigs(this*this', [], nbSingularvalues, type);
        valsU = max(valsU,0); % We round up eventual slightly negative values
        S = sqrt(valsU);

        % Compute the corresponding eigenvectors if in inverted mode
        if invertMode == 1
            U = this'*U*diag(1./diag(S));
        end
        
        % We make sure the order of the singular values is decreasing
        if isequal(type,-1)
            subU.type='()';
            subU.subs={[1:size(U,1)] [size(U,2):-1:1]};
            U = subsref(U, subU);
            subS.type='()';
            subS.subs={[size(S,1):-1:1] [size(S,2):-1:1]};
            S = subsref(S, subS);
        end
    elseif nargout <= 3
        % We compute the eigenvalues on both sides
        [U valsU] = eigs(this*this', [], nbSingularvalues, type);
        valsU = max(valsU,0); % We round up eventual slightly negative values
        S = sqrt(valsU);
        
        % Compute the corresponding eigenvectors
        if invertMode == 1
            V = U;
            U = this'*U*diag(1./diag(S));
        else
            V = this'*U*diag(1./diag(S));
        end

        % We make sure the order of the singular values is decreasing
        if isequal(type,-1)
            subU.type='()';
            subU.subs={[1:size(U,1)] [size(U,2):-1:1]};
            U = subsref(U, subU);
            subS.type='()';
            subS.subs={[size(S,1):-1:1] [size(S,2):-1:1]};
            S = subsref(S, subS);
            subV.type='()';
            subV.subs={[1:size(V,1)] [size(V,2):-1:1]};
            V = subsref(V, subV);
        end
    end

end
