% eigs - partial eigenvalues and eigenvectors
%
% supported formats :
%   e = eigs(a)                   : 6 eigenvalues of with largest magnitude
%   e = eigs(a, [], k)            : k eigenvalues of with largest magnitude
%   [v d] = eigs(a, [], k)        : k eigenvectors and eigenvalues of a
%                                   with largest magnitude (a*v = v*d)
%   [v d] = eigs(a, [], k, sigma) : first k eigenvectors and eigenvalues of
%                                   a smallest in magnitude to sigma.
%                                   With sigma = 'lm' or 'largestabs' for
%                                   eigenvalues with the largest magnitude,
%                                   and sigma = 'sm' or 'smallestabs' for
%                                   eigenvalues with the smallest
%                                   magnitude.
%
% Note:
%  - The precision of the computation performed here may be gem.workingPrecision*2/3
%  - It appears that sometimes the order of two eigenvalues can be
%    inverted, so if this is crucial information, one should double check
%    the last eigenvalues by computing a few more eigenvalues than needed.
function [V D] = eigs(this, varargin)
    % This function can involve at most three parameters
    if length(varargin) > 3
        error('Too many arguments in gem::eigs');
    end

    if size(this,1) ~= size(this,2)
        error('Matrix must be square in gem::eigs');
    end
    
    if (length(varargin) > 0) && (~isempty(varargin{1}))
        error('Second argument in sgem::eigs should be empty');
    end
    
    if (length(varargin) > 1) && (~isnumeric(varargin{2}) || (numel(varargin{2}) ~= 1))
        error('The third argument of gem::eigs must be a single number');
    elseif (length(varargin) > 1) && ~isequal(class(varargin{2}), 'double')
        % We make sure that the number of eigenvalues to be computed was
        % specified as a double
        varargin{2} = double(varargin{2});
    end

    % Extract the requested number of eigenvalues
    if length(varargin) > 1
        nbEigenvalues = varargin{2};
    else
        nbEigenvalues = min(size(this,1), 6);
    end

    % The number of eigenvalues computed must be larger than zero
    if (nbEigenvalues == 0) || isempty(this)
        V = gem([]);
        D = gem([]);
        return;
    elseif nbEigenvalues < 0
        error('gem::eigs cannot compute a negative number of eigenvalues');
    end

    % We check if there is a second parameter
    type = 1;
    sigma = 0;
    if length(varargin) > 2
        if ischar(varargin{3})
            switch lower(varargin{3})
                case {'lm', 'largestabs'}
                    % Largest magnitude
                    type = 1;
                case {'sm', 'smallestabs'}
                    % Smallest magnitude
                    type = 2;
% % The following cases are not implemented at the moment:
%                 case 'lr'
%                     % Largest real component
%                 case 'sr'
%                     % Smallest real component
%                 case 'li'
%                     % Largest imaginary component
%                 case 'si'
%                     % Smallest imaginary component
                otherwise
                    error('Third argument of gem::eigs not recognized');
            end
        else
            if numel(varargin{3}) > 1
                error('sigma must be a single number in gem::eigs');
            end
            type = 2;
            sigma = varargin{3};
        end
    end

    if nbEigenvalues > size(this,1) - 2 + ishermitian(this)
        if nbEigenvalues > size(this,1)
            error('Too many eigenvalues asked for in gem::eigs');
        end

        % We use eig to compute all eigenvalues
        if nargout == 2
            [V D] = eig(this);
            % We make sure the eigenvalues are ordered (not guaranteed by
            % eig)
            [junk reorder] = sort((diag(D)-sigma).^2,1,'descend');
            subD.type='()';
            subD.subs={reorder reorder};
            D = subsref(D, subD);
            subV.type='()';
            subV.subs={':' reorder};
            V = subsref(V, subV);
            if isequal(type, 2)
                subV.type='()';
                subV.subs={[1:size(V,1)] [size(V,2):-1:size(V,2)-nbEigenvalues+1]};
                V = subsref(V, subV);
                subD.type='()';
                subD.subs={[size(D,1):-1:size(D,1)-nbEigenvalues+1] [size(D,2):-1:size(D,2)-nbEigenvalues+1]};
                D = subsref(D, subD);
            elseif nbEigenvalues < size(D,1)
                subV.type='()';
                subV.subs={[1:size(V,1)] [1:nbEigenvalues]};
                V = subsref(V, subV);
                subD.type='()';
                subD.subs={[1:nbEigenvalues] [1:nbEigenvalues]};
                D = subsref(D, subD);
            end
        else
            V = eig(this);
            % We make sure the eigenvalues are ordered by magnitude (not
            % guaranteed by eig)
            [junk reorder] = sort((V-sigma).^2,1,'descend');
            subV.type='()';
            subV.subs={reorder [1]};
            V = subsref(V, subV);
            if isequal(type, 2)
                subV.type='()';
                subV.subs={[size(V,1):-1:size(V,1)-nbEigenvalues+1] [1]};
                V = subsref(V, subV);
            elseif nbEigenvalues < size(V,1)
                subV.type='()';
                subV.subs={[1:nbEigenvalues] [1]};
                V = subsref(V, subV);
            end
        end
        return;
    end

    % We make sure sigma is a gem object
    if ~isequal(class(sigma),'gem')
        sigma = gem(sigma);
    end

    % The algorithm we use doesn't handle eigenvalues equal to sigma. So
    % this variable tells how many times it needs to be added
    % mannually.
    additionalSigmaMultiplicity = 0;

    % We make sure we won't try to find non-zero eigenvalues when there
    % are no more (this is numerically unstable)
    if isequal(type,1)
        rankMatrix = rank(this);
        if rankMatrix < nbEigenvalues
            if rankMatrix == 0
                % This is the null matrix
                if nargout == 1
                    V = gem(zeros(nbEigenvalues,1));
                else
                    V = gem([eye(nbEigenvalues); zeros(size(this,1)-nbEigenvalues, nbEigenvalues)]);
                    D = gem(zeros(nbEigenvalues));
                end
                return;
            end
            additionalSigmaMultiplicity = nbEigenvalues-rankMatrix;
            if nargout >= 2
                VNull = null(this);
                subVNull.type='()';
                subVNull.subs={':' [1:nbEigenvalues-rankMatrix]};
                VNull = subsref(VNull, subVNull);
            end
            nbEigenvalues = rankMatrix;
        end
    end

    % We make sure we won't try to invert a singular matrix (this is
    % numerically unstable as well)
    sigmaShift = 0;
    if isequal(type,2)
        rankShifted = rank(this-sigma*eye(size(this)));
        if size(this,1) - rankShifted >= nbEigenvalues
            % Then we know that all requested eigenvalues are equal to
            % sigma
            V = sigma*ones(nbEigenvalues,1);
            if nargout >= 2
                D = diag(V);
                V = null(this);
                subV.type='()';
                subV.subs={':' [1:nbEigenvalues]};
                V = subsref(V, subV);
            end
            return;
        elseif size(this,1) - rankShifted > 0
            % We slightly shift the value of sigma
            sigmaShift = 10*eps(this);
            sigma = sigma-sigmaShift;
        end
    end

    objId1 = this.objectIdentifier;
    objId2 = sigma.objectIdentifier;
    [newObjectIdentifierV newObjectIdentifierD] = gem_mex('eigs', objId1, nbEigenvalues, type, objId2);

    % ...  and create a new matlab object to keep this handle
    V = gem('encapsulate', newObjectIdentifierV);
    D = gem('encapsulate', newObjectIdentifierD);
    
    % We make sure the eigenvalues are ordered
    if isequal(type, 1)
        [junk reorder] = sort((diag(D)-sigma).^2,1,'descend');
    else % then type is 2
        [junk reorder] = sort((diag(D)-sigma).^2,1,'ascend');
    end
    subD.type='()';
    subD.subs={reorder reorder};
    D = subsref(D, subD);
    subV.type='()';
    subV.subs={':' reorder};
    V = subsref(V, subV);

    % We normalize the eigenvectors (this should not be done if the
    % option 'nobalance' is passed (once this option is implemented)).
    V = V*diag(1./sqrt(diag(V'*V)));

    if additionalSigmaMultiplicity > 0
        D = diag([diag(D); sigma*ones(additionalSigmaMultiplicity,1)]);
        if nargout >= 2
            V = [V VNull];
        end
    end
    
    if nargout <= 1
        V = diag(D);
    end

end
