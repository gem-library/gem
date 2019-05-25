% svd - Singular value decomposition
%
% At the moment, this function is not implemented
function [U S V] = svd(this, varargin)
    error('Svd is not implemented for sparse matrices. Use svds(x) or svd(full(x)) instead.');
end
