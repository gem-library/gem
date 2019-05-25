function Ms = generateDoubleMatrices(n, maxDim, type)
% function Ms = generateDoubleMatrices([n], [maxDim], [type])
%
% This function generates random matrices of a given type for testing
% purposes. It does the same job as generateMatrice, but creates always
% pairs of matrices with identical type and size.
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
% Example: generateDoubleMatrices(2, [2 2], {'RS', 'I'}) puts together a
% set of 2x4 matrices of size at most 2x2. Two of them are real and
% symmetric, two other are guaranteed to be purely imaginary matrices.
% These four matrices can be either sparse of full.


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


%% Now we create the matrices

% First we generate one set of matrices
Ms = generateMatrices(n, maxDim, type);

% We generate another set of matrices with identical dimensions
found = zeros(1, size(Ms, 2));
while ~all(found)
    y = generateMatrices(n, maxDim, type);
    for i = 1:length(y)
        if ~found(i) && isequal(size(Ms{1,i}), size(y{i}))
            Ms{2,i} = y{i};
            found(i) = 1;
        end
    end
end

end
