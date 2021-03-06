function Ms = generateMatrices(n, maxDim, type, nbDuplicates)
% function Ms = generateMatrices([n], [maxDim], [type], [nbDuplicates])
%
% This function generates random matrices of a given type for testing
% purposes.
%
% n is the number of desired matrix of each type (1 by default)
%
% maxDim is an upper bound on the dimension (100 by default)
%
% type is the type of matrix desired. It can be any set of combination of
%      the following letters ('' by default):
%        R: real only
%        I: imaginary only
%        S: symmetric/hermitian only (implies square)
%        Q: square only
%        F: full only
%        P: sparse only, with 90% of zero terms
%        A: sparse only, with typically all nonzero terms
%
% nbDuplicates tells how many matrices of each size should be produces (1 by
%      default)
% 
% Examples:
%  - generateMatrices(1, 5, {'R'}) creates 1 random real matrix of size mxn 
% with m,n <= 5.
% 
%  - generateMatrices(2, [2 2], {'RS', 'I'}, 3) puts together
% a set of 3x4 matrices of size at most 2x2. Two of them are real and
% symmetric, two other are guaranteed to be purely imaginary matrices.
% These four matrices can be either sparse of full.

% TODO : add support for NaN and Inf values

%% Input management
if nargin < 1
    n = 1;
end

if nargin < 2
    maxDim = [100 100];
elseif length(size(maxDim)) == 1
    maxDim = [maxDim maxDim];
elseif length(size(maxDim)) > 2
    error('matrices are at most 2-dimensional');
end

if nargin < 3
    type = {''};
elseif ~isa(type, 'cell')
    type = {type};
end

if nargin < 4
    nbDuplicates = 1;
end


%% Now we create the matrices

Ms = cell(nbDuplicates, n*length(type));

co = 0;
for i = 1:length(type)
    for j = 1:n
        co = co + 1;
        
        % We make sure that 10% of the sampled matrices are square
        forceSquare = (rand < 0.1);
        
        % Square only?
        if ~isempty(strfind(type{i}, 'Q')) || ~isempty(strfind(type{i}, 'S')) || forceSquare
            dim = ceil(rand*min(maxDim))*[1 1];
        else
            dim = ceil(rand(1,2).*maxDim);
        end

        for k = 1:nbDuplicates
            % Real only, imaginary only, or none?
            if ~isempty(strfind(type{i}, 'R'))
                M = gem.rand(dim)*10-5;
            elseif ~isempty(strfind(type{i}, 'I'))
                M = 1i*(gem.rand(dim)*10-5);
            else
                M = gem.rand(dim)*10-5 + 1i*(gem.rand(dim)*10-5);
            end

            % Symmetric/hermitian only?
            if ~isempty(strfind(type{i}, 'S'))
                M = (M + M')/2;
            end

            % Full only, sparse only or both?
            if ~isempty(strfind(type{i}, 'F'))
            elseif ~isempty(strfind(type{i}, 'A'))
                % sparse object full of nonzero numbers
                M = sparse(M);
            elseif ~isempty(strfind(type{i}, 'P')) || (rand > 1/2)
                % We remove 90% of the terms
                sparsity = 1-(1^2./min(dim)).^(1/2);
                M = M.*(rand(dim) < 1-sparsity);
                M = sparse(M);
            end

            Ms{k, co} = M;
        end
    end
end

end
