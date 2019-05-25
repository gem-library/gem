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
%  - The precision of the computation performed here is gem.workingPrecision*2/3
%  - It appears that sometimes the order of two eigenvalues can be
%    inverted, so if this is crucial information, one should double check
%    the last eigenvalues by computing a few more eigenvalues than needed.
function [V D] = eigs(this, varargin)
    % This function can involve at most three parameters
    if length(varargin) > 3
        error('Too many arguments in sgem::eigs');
    end

    if size(this,1) ~= size(this,2)
        error('Matrix must be square in sgem::eigs');
    end
    
    if (length(varargin) > 0) && (~isempty(varargin{1}))
        error('Second argument in sgem::eigs should be empty');
    end
    
    if (length(varargin) > 1) && (~isnumeric(varargin{2}) || (numel(varargin{2}) ~= 1))
        error('The third argument of sgem::eigs must be a single number');
    elseif (length(varargin) > 1) && ~isequal(class(varargin{2}), 'double')
        % We make sure that the number of eigenvalues to be computed was
        % specified as a double
        varargin{2} = double(varargin{2});
    end

    % Extract the requested number of eigenvalues
    if length(varargin) > 1
        nbEigenvalues = varargin{2};
    else
        nbEigenvalues = min(size(this,1) - 2 + ishermitian(this), 6);
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
                    error('Third argument of sgem::eigs not recognized');
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
        error('Too many eigenvalues for sgem::eigs');
    end

    % The matrix must be square
    if size(this, 1) ~= size(this,2)
        error('Matrix must be square in sgem::eigs');
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
            if nargout >= 2
                error('Eigenvectors are not computed for null eigenvalues.')
            end
            if rankMatrix == 0
                % This is the null matrix
                V = gem(0);
                return;
            elseif rankMatrix == 1
                warning('There is only one non-zero eigenvalues, computing this one only.');
            else
                warning(['There are only ', num2str(rankMatrix), ' non-zero eigenvalues, computing these ones only.']);
            end
            additionalSigmaMultiplicity = nbEigenvalues-rankMatrix;
            nbEigenvalues = rankMatrix;
        end
    end

    % We make sure we won't try to invert a singular matrix (this is
    % numerically unstable as well)
    if isequal(type,2)
        rankShifted = rank(this-sigma*eye(size(this)));
        if size(this,1) - rankShifted >= nbEigenvalues
            % Then we know that all requested eigenvalues are equal to
            % sigma, but we still haven't computed corresponding
            % eigenvectors (these would be given by a function such as
            % 'null')
            V = sigma*ones(nbEigenvalues,1);
            if nargout >= 2
                error('Eigenvectors are not computed when sigma is an eigenvalue.')
            end
            return;
        elseif size(this,1) - rankShifted > 0
            error('Sigma is an eigenvalue of the considered matrix. Consider perturbing it a little bit to allow the numerical method to run smoothly.')
        end
    end

    objId1 = this.objectIdentifier;
    objId2 = sigma.objectIdentifier;
    [newObjectIdentifierV newObjectIdentifierD] = sgem_mex('eigs', objId1, nbEigenvalues, type, objId2);

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

    if nargout <= 1
        V = diag(D);
        if additionalSigmaMultiplicity > 0
            V = [V; sigma*ones(additionalSigmaMultiplicity,1)];
        end
    end

end
