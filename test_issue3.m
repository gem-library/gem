x = gem([                       0                                                0 - 0.3545006691647150000i                       0 + 0.7994528167513530000i
0 + 0.3545006691647150000i                       0                                                0 - 2.3154468429399400000i
0 - 0.7994528167513530000i                       0 + 2.3154468429399400000i                       0                         ]);
[U S V] = svd(x, 'econ');
U*S*V'-x % is far from null because...
U'*U % is far from the identity

%%
xx = [real(x) imag(x); -imag(x) real(x)]
[UU SS VV] = svd(xx, 'econ');



%% Let's check some additional special cases
% We generate some unitary
r = gem.rand(6) + 1i*gem.rand(6);
r = r + r';
[a b] = eig(r);
d = diag(b);

%x = a*diag(d([1 1 3:end]))*a';
%x = a*diag(d([1 1 1 4:end]))*a';
%x = a*diag(d([1 1 1 1 5:end]))*a';
%x = a*diag(d([1 1 1 1 1 6]))*a';
%x = a*diag(d([1 1 1 1 1 1]))*a';
%x = a*diag(d([1 2 2 4:end]))*a';
%x = a*diag(d([1 2 2 2 5:end]))*a';
%x = a*diag(d([1 2 2 2 2 6]))*a';
x = a*diag(d([1 2 2 2 2 2]))*a';
%x = a*diag(d([1 2 3 3 5:6]))*a';
%x = a*diag(d([1 2 3 3 3 6]))*a';
%x = a*diag(d([1 2 3 3 3 3]))*a';
x = a*diag(d([1 1 3 3 5 6]))*a';

which = ceil(6*rand(1,6));
d(which)
x = a*diag(d(which))*a';


[q w e] = svd(x, 'econ');
double(q'*q)
norm(double(q'*q)-eye(size(q)))
double(e'*e)
norm(double(e'*e)-eye(size(e)))

q*w*e'-x

q*w - x*e

% Even though the orthogonalization works, the decomposition is wrong!!
% So this is not enough, we need to be more clever.
