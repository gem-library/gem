% null - subspace of zero eigenvalue
%
% supported formats :
%   z = null(a)                   : resturns a orthonormal basis for the
%                                   null space of a
function z = null(this)

[m,n] = size(this);

% special case
if isempty(this)
    Z = gem(eye(n));
    return
end

% decompose the space
[U,S,V] = svd(this,0);
if m == 1
    s = S(1);
else
    s = diag(S);  
end

% identify close to zero values
tol = max(m,n) * sqrt(eps(max(s)));
r = sum(s > tol);

% extract the relevant part
sub.type='()';
sub.subs={':', r+1:n};
z = subsref(V, sub);
