x = gem([                       0                                                0 - 0.3545006691647150000i                       0 + 0.7994528167513530000i
0 + 0.3545006691647150000i                       0                                                0 - 2.3154468429399400000i
0 - 0.7994528167513530000i                       0 + 2.3154468429399400000i                       0                         ]);
[U S V] = svd(x, 'econ');
U*S*V'-x % is far from null because...
U'*U % is far from the identity


xx = [real(x) imag(x); -imag(x) real(x)]
[UU SS VV] = svd(xx, 'econ');



%% Let's check some additional special cases
% We generate some unitary
r = gem.rand(6) + 1i*gem.rand(6);
r = r + r';
[a b] = eig(r);
d = diag(b);

x = a*diag(d([1 1 1 4:end]))*a';

[q w] = svd(x, 'econ');
double(q'*q)
